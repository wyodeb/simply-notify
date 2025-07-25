# frozen_string_literal: true

require_relative 'notification_channel'
module SimplyNotify
  class SmsChannel
    include NotificationChannel

    def deliver(user, message)
      "SMS sent to #{user.phone}: #{message}"
    end
  end
end
