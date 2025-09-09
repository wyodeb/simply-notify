# frozen_string_literal: true

require 'monitor'

module SimplyNotify
  class DeliveryLog
    Entry = Struct.new(:user_id, :channel, :status, :message, :at, keyword_init: true)

    def initialize
      @entries = []
      @mon = Monitor.new
    end

    def log(user, channel, status, message)
      @mon.synchronize do
        @entries << Entry.new(
          user_id: user.id,
          channel: channel,
          status: status,
          message: message,
          at: Time.now
        )
      end
    end

    def all
      @mon.synchronize { @entries.dup }
    end

    def where(user_id: nil, channel: nil, status: nil)
      @mon.synchronize do
        @entries.select do |e|
          (user_id.nil? || e.user_id == user_id) &&
            (channel.nil? || e.channel == channel) &&
            (status.nil? || e.status == status)
        end
      end
    end
  end
end
