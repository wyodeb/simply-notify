# SimplyNotify
A minimal, gem-structured Ruby notification engine demo.  
Delivers messages to users via pluggable channels (email, SMS, in-app), supporting subscription and unsubscription.

## Features
- Pluggable notification channels
- User can subscribe/unsubscribe to any channel
- Encapsulated, testable OOP design
- Service object pattern (`NotificationService`)
- Delivery logging
- Data-driven demo: load users from JSON
- Minitest test suite, Rake integration

## Project Structure
```
lib/
simply_notify.rb
simply_notify/
user.rb, notification_channel.rb, ...
test/
test_helper.rb, user_test.rb, ...
cli.rb
Rakefile
simply_notify.gemspec
users.json
```

# Quick run
1. **Demo CLI:**
    ```sh
    ruby cli.rb
    ```
    - Users loaded from `users.json`
    - See notifications sent, delivery log, and channel subscription changes

2. **Run tests:**
    ```sh
    rake
    ```
   
## How to Use
- **Add or edit users:** Edit `users.json`.  
  Example user entry:
  ```json
  {
    "name": "Demo",
    "email": "demo@example.com",
    "phone": "12345",
    "channels": ["email", "sms"]
  }

Assuming `user` is a `SimplyNotify::User` instance:
```ruby
user.subscribe(:in_app)    # Adds :in_app channel
user.unsubscribe(:email)   # Removes :email channel

# Example for an existing user loaded from JSON:
users = JSON.parse(File.read("users.json")).map do |attrs|
  SimplyNotify::User.new(
    name: attrs["name"],
    email: attrs["email"],
    phone: attrs["phone"],
    channels: attrs["channels"].map(&:to_sym)
  )
end

demo = users.first
demo.subscribe(:in_app)
demo.unsubscribe(:email)
```
## What’s not included
- Real SMS/email/in-app integration (channel classes are stubs)
- Input validation
- Database or persistence

## License
MIT

