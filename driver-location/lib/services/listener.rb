# frozen_string_literal: true

require 'nsq'

module Services
  class Listener
    TOPIC = 'locations'.freeze
    CHANNEL = 'drivers'.freeze
    NSQLOOKUPD = "#{ENV['NSQ_HOST']}:#{ENV['NSQ_PORT']}".freeze

    attr_reader :nsq_consumer, :writer

    def initialize(nsq_consumer: Nsq::Consumer, writer: Services::Redis::CoordinatesWriter.new)
      @nsq_consumer = nsq_consumer
      @writer = writer
    end

    def call
      if (msg = consumer.pop_without_blocking)
        begin
          response = JSON.parse(msg.body)
          writer.call(response, msg.timestamp)
          msg.finish
        rescue JSON::JSONError
          msg.finish
        end
      else
        # wait for a bit before checking for new messages
        sleep 0.01
      end
    end

    private

    def consumer
      @consumer ||= nsq_consumer.new(
        nsqlookupd: NSQLOOKUPD,
        topic: TOPIC,
        channel: CHANNEL
      )
    end
  end
end
