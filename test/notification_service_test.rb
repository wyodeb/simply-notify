# frozen_string_literal: true

require_relative 'test_helper'

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

  def test_notify_logs_success
    @service.notify(@user, 'Hi!')
    log = @service.log.all
    assert_equal 2, log.size
    assert_equal :success, log.first.status
    assert_match(/Hi!/, log.first.message)
  end

  def test_notify_with_unsubscribed_channel
    @user.unsubscribe(:sms)
    @service.notify(@user, 'Test')
    log = @service.log.all
    assert_equal 1, log.size
    assert_equal :email, log.first.channel
  end

  def test_available_channels
    chans = @service.available_channels
    assert_includes chans, :email
    assert_includes chans, :sms
    assert_includes chans, :in_app
  end
end
