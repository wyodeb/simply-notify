# frozen_string_literal: true

require 'securerandom'

module SimplyNotify
  class User
    attr_reader :id, :name, :email, :phone
    attr_accessor :channels

    def initialize(name:, email:, phone:, channels: [], id: SecureRandom.uuid)
      @id = id
      @name = name
      @email = email
      @phone = phone
      @channels = channels.map(&:to_sym).uniq
    end

    def subscribe(channel)
      c = channel.to_sym
      @channels << c unless @channels.include?(c)
    end

    def unsubscribe(channel)
      @channels.delete(channel.to_sym)
    end
  end
end
