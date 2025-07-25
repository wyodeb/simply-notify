# frozen_string_literal: true

require_relative 'test_helper'

class ChannelTest < Minitest::Test
  def setup
    @user = SimplyNotify::User.new(
      name: 'Test User',
      email: 'test@example.com',
      phone: '12345',
      channels: %i[email sms in_app]
    )
  end

  def test_email_channel_deliver
    chan = SimplyNotify::EmailChannel.new
    result = chan.deliver(@user, 'Hello!')
    assert_match(/Email sent to test@example.com: Hello!/, result)
  end

  def test_sms_channel_deliver
    chan = SimplyNotify::SmsChannel.new
    result = chan.deliver(@user, 'Hello!')
    assert_match(/SMS sent to 12345: Hello!/, result)
  end

  def test_in_app_channel_deliver
    chan = SimplyNotify::InAppChannel.new
    result = chan.deliver(@user, 'Hello!')
    assert_match(/In-app notification to Test User: Hello!/, result)
  end
end
