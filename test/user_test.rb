# frozen_string_literal: true

require_relative 'test_helper'

class UserTest < Minitest::Test
  def test_initial_channels
    user = SimplyNotify::User.new(
      name: 'Demo',
      email: 'demo@example.com',
      phone: '12345',
      channels: %i[email sms]
    )
    assert_equal %i[email sms], user.channels
  end

  def test_initial_channels_are_symbolized_and_deduped
    user = SimplyNotify::User.new(
      name: 'Demo',
      email: 'demo@example.com',
      phone: '12345',
      channels: ['email', :email, 'sms']
    )
    assert_equal %i[email sms], user.channels
  end

  def test_subscribe
    user = SimplyNotify::User.new(name: 'Test', email: 't@e', phone: '1', channels: [])
    user.subscribe(:sms)
    assert_includes user.channels, :sms
  end

  def test_subscribe_is_idempotent_and_symbolizes
    user = SimplyNotify::User.new(name: 'Test', email: 't@e', phone: '1', channels: [:email])
    user.subscribe('email')
    user.subscribe(:email)
    assert_equal [:email], user.channels
  end

  def test_unsubscribe
    user = SimplyNotify::User.new(name: 'Test', email: 't@e', phone: '1', channels: %i[email sms])
    user.unsubscribe(:email)
    refute_includes user.channels, :email
    assert_equal [:sms], user.channels
  end

  def test_unsubscribe_nonexistent_is_noop
    user = SimplyNotify::User.new(name: 'Test', email: 't@e', phone: '1', channels: [:email])
    user.unsubscribe(:sms) # should not raise or change existing channels
    assert_equal [:email], user.channels
  end

  def test_id_is_uuid_by_default
    user = SimplyNotify::User.new(name: 'UUID', email: 'u@e', phone: '999')
    assert_match(/\A[0-9a-f-]{36}\z/, user.id) # simple UUID format check
  end

  def test_id_can_be_overridden
    user = SimplyNotify::User.new(name: 'Override', email: 'o@e', phone: '888', id: 'fixed-id')
    assert_equal 'fixed-id', user.id
  end
end
