class DeliveryLog
  Entry = Struct.new(:user_id, :channel, :status, :message)

  def initialize
    @entries = []
  end

  def log(user, channel, status, message)
    @entries << Entry.new(user.id, channel, status, message)
  end

  def all
    @entries
  end
end
