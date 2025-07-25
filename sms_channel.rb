require_relative 'notification_channel'
class SmsChannel
  include NotificationChannel

  def deliver(user, message)
    "SMS sent to #{user.phone}: #{message}"
  end
end
