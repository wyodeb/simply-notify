require_relative 'notification_channel'
class InAppChannel
  include NotificationChannel

  def deliver(user, message)
    "In-app notification to #{user.name}: #{message}"
  end
end
