# frozen_string_literal: true

require_relative 'notification_channel'

module SimplyNotify
  class InAppChannel
    include NotificationChannel

    def deliver(user, message)
      "In-app notification to #{user.name}: #{message}"
    end
  end
end
