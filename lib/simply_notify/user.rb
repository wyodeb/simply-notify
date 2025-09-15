# frozen_string_literal: true

require 'securerandom'
require 'set'

module SimplyNotify
  class User
    attr_reader :id, :name, :email, :phone, :channels

    def initialize(name:, email:, phone:, channels: [], id: SecureRandom.uuid)
      @id = id
      @name = name
      @email = email
      @phone = phone
      @channels = Set.new(channels.map(&:to_sym))
    end

    def subscribe(channel)
      @channels.add(channel.to_sym)
    end

    def unsubscribe(channel)
      @channels.delete(channel.to_sym)
    end
  end
end
