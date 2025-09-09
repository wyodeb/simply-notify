# frozen_string_literal: true

module SimplyNotify
  Result = Struct.new(
    :user_id, :channel, :ok, :value, :error_class, :error_message, :at,
    keyword_init: true
  )
end
