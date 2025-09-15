# frozen_string_literal: true

require_relative 'test_helper'
require 'set'

class NotificationServiceTest < Minitest::Test
  def setup
    @user = SimplyNotify::User.new(
      name: 'Test User',
      email: 'test@example.com',
      phone: '12345',
      channels: %i[email sms]
    )
    @service = SimplyNotify::NotificationService.new
  end

  def test_notify_logs_success_and_returns_results
    results = @service.notify(@user, 'Hi!')
    assert_equal 2, results.size
    assert results.all?(&:ok)
    assert_equal %i[email sms].to_set, results.map(&:channel).to_set
    assert(results.all? { |r| r.user_id == @user.id })
    assert(results.all? { |r| r.value.include?('Hi!') })

    log = @service.log.all
    assert_equal 2, log.size
    assert(log.all? { |e| e.status == :success })
    assert(log.all? { |e| e.message.include?('Hi!') })
    assert(log.all? { |e| e.user_id == @user.id })
  end

  def test_notify_with_unsubscribed_channel
    @user.unsubscribe(:sms)
    results = @service.notify(@user, 'Test')
    assert_equal 1, results.size
    assert_equal :email, results.first.channel

    log = @service.log.all
    assert_equal 1, log.size
    assert_equal :email, log.first.channel
    refute(log.any? { |e| e.channel == :sms })
  end

  def test_available_channels
    chans = @service.available_channels
    assert_includes chans, :email
    assert_includes chans, :sms
    assert_includes chans, :in_app
  end

  # Forwardable-specific checks
  def test_keys_delegates_to_registry
    assert_respond_to @service, :keys
    assert_equal @service.available_channels, @service.keys
  end

  def test_keys_reflects_injected_registry
    reg = SimplyNotify::ChannelRegistry.new(foo: Class.new)
    svc = SimplyNotify::NotificationService.new(registry: reg)
    assert_equal [:foo], svc.keys
  end

  # Filters: only / except
  def test_notify_with_only_filters_down_to_requested_channels
    results = @service.notify(@user, 'Only SMS', only: :sms)
    assert_equal [:sms], results.map(&:channel)
    assert(results.all?(&:ok))

    log = @service.log.all.last(1)
    assert_equal :sms, log.first.channel
    assert_equal :success, log.first.status
  end

  def test_notify_with_except_removes_requested_channels
    results = @service.notify(@user, 'Skip email', except: :email)
    assert_equal [:sms], results.map(&:channel)
    assert(results.all?(&:ok))

    log = @service.log.all.last(1)
    assert_equal :sms, log.first.channel
    assert_equal :success, log.first.status
  end

  def test_notify_with_only_and_except_conflict_prefers_except
    results = @service.notify(@user, 'Conflict', only: [:email, :sms], except: :sms)
    assert_equal [:email], results.map(&:channel)
  end

  def test_notify_normalizes_string_filters
    results = @service.notify(@user, 'Strings ok', only: 'sms', except: nil)
    assert_equal [:sms], results.map(&:channel)

    results2 = @service.notify(@user, 'Strings ok 2', only: nil, except: ['email'])
    assert_equal [:sms], results2.map(&:channel)
  end
end
