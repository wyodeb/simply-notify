# frozen_string_literal: true

module SimplyNotify
  class ChannelRegistry
    def initialize(map)
      @map = map.transform_keys!(&:to_sym).freeze
    end

    def fetch(key)
      @map[key.to_sym]
    end

    def keys
      @map.keys
    end
  end
end
