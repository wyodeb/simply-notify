# frozen_string_literal: true

require 'forwardable'
require_relative 'result'
require_relative 'delivery_log'
require_relative 'email_channel'
require_relative 'sms_channel'
require_relative 'in_app_channel'
require_relative 'channel_registry'

module SimplyNotify
  class NotificationService
    extend Forwardable
    def_delegators :@registry, :keys

    def initialize(registry: default_registry, log: DeliveryLog.new)
      @registry = registry
      @log = log
    end

    # Returns an array of Result objects
    def notify(user, message, only: nil, except: nil)
      channels = normalize_channels(user.channels, only: only, except: except)
      results = []

      channels.each do |chan|
        channel_obj = build_channel(chan)
        next unless channel_obj

        begin
          value = channel_obj.deliver(user, message)
          @log.log(user, chan, :success, value)
          results << Result.new(
            user_id: user.id, channel: chan, ok: true, value: value, at: Time.now
          )
        rescue StandardError => e
          @log.log(user, chan, :error, "#{e.class}: #{e.message}")
          results << Result.new(
            user_id: user.id, channel: chan, ok: false,
            error_class: e.class.name, error_message: e.message, at: Time.now
          )
        end
      end

      results
    end

    def available_channels
      @registry.keys
    end

    attr_reader :log

    private

    def normalize_channels(user_channels, only:, except:)
      set = user_channels.map(&:to_sym)
      set &= Array(only).map(&:to_sym) if only
      set -= Array(except).map(&:to_sym) if except
      set
    end

    def build_channel(key)
      klass = @registry.fetch(key)
      klass&.new
    end

    def default_registry
      ChannelRegistry.new(
        email: SimplyNotify::EmailChannel,
        sms: SimplyNotify::SmsChannel,
        in_app: SimplyNotify::InAppChannel
      )
    end
  end
end
