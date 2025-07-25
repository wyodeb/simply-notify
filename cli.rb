# frozen_string_literal: true

base_dir = __dir__ || '.' # Sorbet be quiet please
$LOAD_PATH.unshift(File.expand_path('lib', base_dir))
require 'simply_notify'
require 'json'

module SimplyNotifyDemo
  BASE_DIR = __dir__
  USERS_FILE = File.expand_path('data/users.json', BASE_DIR)

  def self.run
    users = load_users_from_json
    service = SimplyNotify::NotificationService.new

    send_initial_notifications(service, users)
    print_delivery_log(service)

    manage_subscriptions(users.first)
    send_followup_notification(service, users.first)
    print_delivery_log(service)
  end

  def self.load_users_from_json
    data = JSON.parse(File.read(USERS_FILE))
    data.map do |user_hash|
      SimplyNotify::User.new(
        name: user_hash['name'],
        email: user_hash['email'],
        phone: user_hash['phone'],
        channels: user_hash['channels'].map(&:to_sym)
      )
    end
  end

  def self.send_initial_notifications(service, users)
    puts '== Sending notifications =='
    users.each do |user|
      service.notify(user, "Welcome #{user.name}!")
    end
  end

  def self.send_followup_notification(service, user)
    puts "\n== Sending notifications after subscription changes =="
    service.notify(user, "Update for #{user.name} after subscription change!")
  end

  def self.print_delivery_log(service)
    puts "\n== Delivery log =="
    service.log.all.each do |entry|
      puts "#{entry.channel} to user##{entry.user_id} - #{entry.status}: #{entry.message}"
    end
  end

  def self.manage_subscriptions(user)
    puts "\n== Managing subscriptions =="
    show_channels(user)
    user.unsubscribe(:sms)
    puts "#{user.name} unsubscribed from :sms"
    show_channels(user)
    user.subscribe(:in_app)
    puts "#{user.name} subscribed to :in_app"
    show_channels(user)
  end

  def self.show_channels(user)
    puts "User ##{user.id} channels: #{user.channels.map(&:to_s).join(', ')}"
  end
end

SimplyNotifyDemo.run
