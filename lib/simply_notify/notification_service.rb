# frozen_string_literal: true

require_relative 'email_channel'
require_relative 'sms_channel'
require_relative 'in_app_channel'
require_relative 'delivery_log'

module SimplyNotify
  class NotificationService
    CHANNELS = {
      email: EmailChannel.new,
      sms: SmsChannel.new,
      in_app: InAppChannel.new
    }.freeze

    def initialize(log: DeliveryLog.new)
      @log = log
    end

    def notify(user, message)
      user.channels.each do |chan|
        channel_obj = CHANNELS[chan]
        next unless channel_obj

        begin
          status = channel_obj.deliver(user, message)
          @log.log(user, chan, :success, status)
        rescue StandardError => e
          @log.log(user, chan, :error, e.message)
        end
      end
    end

    attr_reader :log

    def available_channels
      CHANNELS.keys
    end
  end
end
