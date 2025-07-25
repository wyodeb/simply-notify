# frozen_string_literal: true

module SimplyNotify
  module NotificationChannel
    def deliver(user, message)
      raise NotImplementedError, 'Subclasses must implement deliver'
    end
  end
end
