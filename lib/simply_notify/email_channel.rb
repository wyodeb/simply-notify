require_relative 'notification_channel'

module SimplyNotify
  class EmailChannel
    include NotificationChannel

    def deliver(user, message)
      "Email sent to #{user.email}: #{message}"
    end
  end
end
