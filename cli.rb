# frozen_string_literal: true

base_dir = __dir__ || '.'
$LOAD_PATH.unshift(File.expand_path('lib', base_dir))

require 'simply_notify'
require 'json'
require 'set'

module SimplyNotifyDemo
  BASE_DIR   = __dir__
  USERS_FILE = File.expand_path('data/users.json', BASE_DIR)

  def self.run
    users   = load_users_from_json
    service = SimplyNotify::NotificationService.new

    puts "Available channels: #{service.available_channels.join(', ')}"

    send_initial_notifications(service, users)
    print_delivery_log(service)

    manage_subscriptions(users.first)
    send_followup_notification(service, users.first)
    print_delivery_log(service)
  end

  def self.load_users_from_json
    unless File.exist?(USERS_FILE)
      warn "Users file not found at #{USERS_FILE}"
      exit 1
    end

    data = JSON.parse(File.read(USERS_FILE))
    allowed = SimplyNotify::NotificationService.new.available_channels.to_set

    data.map do |user_hash|
      raw_channels = Array(user_hash['channels'])
      # Normalize + validate channels against registry
      channels = raw_channels.map(&:to_sym).select { |c| allowed.include?(c) }.uniq

      SimplyNotify::User.new(
        name: user_hash['name'],
        email: user_hash['email'],
        phone: user_hash['phone'],
        channels: channels
      )
    end
  end

  def self.send_initial_notifications(service, users)
    puts "\n== Sending notifications =="
    users.each do |user|
      results = service.notify(user, "Welcome #{user.name}!")
      print_results(user, results)
    end
  end

  def self.send_followup_notification(service, user)
    puts "\n== Sending notifications after subscription changes =="
    results = service.notify(user, "Update for #{user.name} after subscription change!")
    print_results(user, results)
  end

  def self.print_results(user, results)
    results.each do |r|
      if r.ok
        puts "[OK]  #{r.channel} → #{user.name} (#{user.id}): #{r.value}"
      else
        puts "[ERR] #{r.channel} → #{user.name} (#{user.id}): #{r.error_class} - #{r.error_message}"
      end
    end
  end

  def self.print_delivery_log(service)
    puts "\n== Delivery log =="
    service.log.all.each do |entry|
      puts "#{entry.at.utc.iso8601} | #{entry.channel} → user##{entry.user_id} | #{entry.status}: #{entry.message}"
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
