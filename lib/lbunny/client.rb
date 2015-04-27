module Lbunny
  class Client
    attr_reader :exchange, :channel, :err_block

    def initialize(url, &err_block)
      @url = url
      @exchange = nil
      @err_block = err_block
    end

    def publish(msg, options)
      reconnect! if exchange.nil?
      exchange.publish(msg, options)
    rescue Bunny::TCPConnectionFailed => e
      err_block.call(e) if err_block

      # If disconnected, reconnect and retry once
      reconnect!
      exchange.publish(msg, options)
    end

    def subscribe(queue, routing_key, sub_options = {}, &block)
      reconnect! if exchange.nil?
      fail 'No active channel' if channel.nil?

      channel.queue(queue)
             .bind(exchange, routing_key: routing_key)
             .subscribe(sub_options, &block)
    end

    def close!
      channel.close unless channel.nil?
      @channel = nil
      @exchange = nil
    end

    private

    def reconnect!
      @channel  = conn.create_channel
      @exchange = channel.topic('lb', auto_delete: false, durable: true)
    rescue Bunny::TCPConnectionFailed => e
      err_block.call(e) if err_block
      close!
    end

    def conn
      @conn ||= Bunny.new(@url).tap do |connection|
        connection.start
      end
    end
  end
end
