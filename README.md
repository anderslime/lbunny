# Lbunny

A little tiny wrapper for Lokalebasen's basic usage of Bunny.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lbunny'
```

And then `bundle`

This gem is a client for RabbitMQ. To test this locally you must have
a RabbitMQ broker installed. With Homebrew, do:

```
brew install rabbitmq
```

## Usage

```ruby
# Initialize with url to RabbitMQ
rabbit_url = "amqp://guest:guest@localhost:5672"

client = Lbunny::Client.new(rabbbit_url)

# Setup a blocking subscriber
routing_key = nil
client.subscribe("myqueuename", routing_key, { block: true }) do |delivery_info, props, payload|
  puts payload
end

# To publish messages
client.publish("Hello world", {})
```

For more documentation, see: [Bunny Documentation](http://rubybunny.info/)
