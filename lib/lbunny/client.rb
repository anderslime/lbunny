module Lbunny
  class Client
    attr_reader :exchange, :channel, :err_block, :options

    def initialize(url, options = default_options, &err_block)
      @url = url
      @exchange = nil
      @options = options
      @err_block = err_block
    end

    def publish(msg, options)
      reconnect! unless alive?
      exchange.publish(msg, options)
    rescue => e
      handle_error(e) do
        # If disconnected, reconnect and retry once
        reconnect!
        exchange.publish(msg, options)
      end
    end

    def subscribe(queue, routing_key, sub_options = {}, &block)
      reconnect! unless alive?
      fail 'No active channel' if channel.nil?

      channel.queue(queue)
             .bind(exchange, routing_key: routing_key)
             .subscribe(sub_options, &block)
    rescue => e
      handle_error(e)
    end

    def close!
      channel.close if alive?
      @channel = nil
      @exchange = nil
    rescue => e
      handle_error(e)
    end

    def reconnect!
      @channel  = conn.create_channel
      @channel.prefetch(options[:prefetch_count]) if options[:prefetch_count]
      @exchange = channel.topic('lb', auto_delete: false, durable: true)
    rescue => e
      handle_error(e) do
        close!
      end
    end

    def alive?
      return false if exchange.nil?
      return false if channel.nil?
      channel.open?
    end

    private

    def conn
      @conn ||= Bunny.new(@url).tap do |connection|
        connection.start
      end
    end

    def handle_error(e, &other)
      err_block.call(e) if err_block

      if other
        other.call
      else
        raise e
      end
    end

    def default_options
      {
        prefetch_count: 10
      }
    end
  end
end
