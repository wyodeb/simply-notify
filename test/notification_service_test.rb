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
end
