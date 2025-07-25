# frozen_string_literal: true

require_relative 'notification_system'

def show_channels(user)
  puts "User ##{user.id} channels: #{user.channels.map(&:to_s).join(', ')}"
end


alice = User.new(name: 'Alice', email: 'alice@example.com', phone: '12345', channels: [:email, :sms])



service = NotificationService.new


puts '== Sending notifications =='
service.notify(alice, 'Welcome Alice!')
service.notify(bob, 'Welcome Bob!')


puts "\n== Delivery log =="
service.log.all.each do |entry|
  puts "#{entry.channel} to user##{entry.user_id} - #{entry.status}: #{entry.message}"
end


puts "\n== Managing subscriptions =="
show_channels(alice)
alice.unsubscribe(:sms)
puts 'Alice unsubscribed from :sms'
show_channels(alice)
alice.subscribe(:in_app)
puts 'Alice subscribed to :in_app'
show_channels(alice)

puts "\n== Sending notifications after subscription changes =="
service.notify(alice, 'Update for Alice after subscription change!')


puts "\n== Final delivery log =="
service.log.all.each do |entry|
  puts "#{entry.channel} to user##{entry.user_id} - #{entry.status}: #{entry.message}"
end
