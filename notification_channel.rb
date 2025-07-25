module NotificationChannel
  def deliver(user, message)
    raise NotImplementedError, 'Subclasses must implement deliver'
  end
end
