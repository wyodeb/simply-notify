class User
  attr_reader :id, :name, :email, :phone
  attr_accessor :channels

  @@id_counter = 1

  def initialize(name:, email:, phone:, channels: [])
    @id = @@id_counter
    @@id_counter += 1
    @name = name
    @email = email
    @phone = phone
    @channels = channels.map(&:to_sym)
  end

  def subscribe(channel)
    channel = channel.to_sym
    @channels << channel unless @channels.include?(channel)
  end

  def unsubscribe(channel)
    channel = channel.to_sym
    @channels.delete(channel)
  end
end
