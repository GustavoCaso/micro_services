# frozen_string_literal: true
require 'nsq'
require_relative 'redis'

class Listener
  def self.call
    consumer = Nsq::Consumer.new(
      nsqlookupd: '127.0.0.1:4161',
      topic: 'locations',
      channel: 'drivers'
    )

    loop do
      if msg = consumer.pop_without_blocking
        response = JSON.parse(msg.body)
        time = msg.timestamp
        score = time.to_i
        puts "SCORE: #{score}"
        key = "drivers:coordinates:#{response['driver']}"
        data = response['coordinates'].merge('updated_at' => msg.timestamp.to_s)
        REDIS.zadd(key, score, data.to_json)
        msg.finish
      else
        # wait for a bit before checking for new messages
        sleep 0.01
      end
    end
  end
end
