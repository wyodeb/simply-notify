# SimplyNotify

A minimal, gem-structured Ruby **notification engine demo**.  
Delivers messages to users via pluggable channels (email, SMS, in-app).  
Users can subscribe/unsubscribe from channels, notifications are logged, and the engine is fully testable.

---

## Features

- **Pluggable channels**: Email, SMS, In-App (easy to extend with new ones)
- **User subscriptions**: Subscribe/unsubscribe per channel
- **Service object**: `NotificationService` orchestrates fan-out
- **DeliveryLog**: Thread-safe, queryable log of all sends
- **Result objects**: Structured return from `notify` (per-channel status)
- **UUID users**: `User#id` defaults to a UUID, or can be overridden
- **Demo CLI**: Load users from JSON, simulate notifications
- **Minitest suite**: Full coverage of User, Channels, and Service


---

## Project Structure

```
lib/
  simply_notify.rb
  simply_notify/
    user.rb
    notification_channel.rb
    email_channel.rb
    sms_channel.rb
    in_app_channel.rb
    delivery_log.rb
    result.rb
    channel_registry.rb
    notification_service.rb
test/
  test_helper.rb
  user_test.rb
  channel_test.rb
  notification_service_test.rb
cli.rb
Rakefile
simply_notify.gemspec
data/users.json
```

---

## Quick Run

### 1. Demo CLI
```sh
ruby cli.rb
```

- Loads users from `data/users.json`
- Sends a “Welcome” notification via all their channels
- Prints results and delivery log
- Demonstrates unsubscribe/subscribe flow and re-sending

### 2. Run Tests
```sh
rake
```

Runs the full Minitest suite.

---

## How to Use

### Define Users
Users are plain Ruby objects:

```ruby
user = SimplyNotify::User.new(
  name: "Alice",
  email: "alice@example.com",
  phone: "12345",
  channels: [:email, :sms]
)
```

UUIDs are auto-assigned:

```ruby
user.id # => "c94a38a0-5d8f-4c3a-b7b7-b7a19a4ff981"
```

### Manage Subscriptions
```ruby
user.subscribe(:in_app)   # adds channel
user.unsubscribe(:sms)    # removes channel
```

### Send Notifications
```ruby
service = SimplyNotify::NotificationService.new
results = service.notify(user, "Hello from SimplyNotify!")

results.each do |r|
  if r.ok
    puts "[OK] #{r.channel}: #{r.value}"
  else
    puts "[ERR] #{r.channel}: #{r.error_class} - #{r.error_message}"
  end
end
```

### Inspect Delivery Log
```ruby
service.log.all.each do |entry|
  puts "#{entry.at} | #{entry.channel} → user##{entry.user_id} | #{entry.status}"
end
```

---

## Example `users.json`

```json
[
  {
    "name": "Demo User",
    "email": "demo@example.com",
    "phone": "12345",
    "channels": ["email", "sms"]
  }
]
```

---

## What’s Not Included

- Real SMS/email/in-app integration (stubbed channels only)
- Input validation / sanitization
- Database or persistence

---

## License

MIT
