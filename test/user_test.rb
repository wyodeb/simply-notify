
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

  def test_subscribe
    user = SimplyNotify::User.new(name: 'Test', email: 't@e', phone: '1', channels: [])
    user.subscribe(:sms)
    assert_includes user.channels, :sms
  end

  def test_unsubscribe
    user = SimplyNotify::User.new(name: 'Test', email: 't@e', phone: '1', channels: %i[email sms])
    user.unsubscribe(:email)
    refute_includes user.channels, :email
    assert_equal [:sms], user.channels
  end
end
