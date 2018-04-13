# frozen_string_literal: true
require 'nsq'

module Protocols
  class Nsq
    NSQD = "#{ENV['NSQ_HOST']}:#{ENV['NSQ_PORT']}".freeze

    attr_reader :topic, :producer

    def initialize(data, producer: ::Nsq::Producer)
      @topic = data['topic']
      @producer = producer
    end

    def call(app, keys_from_params)
      param_values = extract_params(app.params, keys_from_params)
      payload = JSON.parse(app.request.body.read)

      nsq_producer = producer.new(
        nsqd: NSQD,
        topic: topic
      )

      message = payload.merge(param_values)

      nsq_producer.write(message.to_json)
      nsq_producer.terminate
      200
    rescue JSON::JSONError
      500
    end

    private

    def extract_params(params, keys_from_params)
      keys_from_params.each_with_object({}) do |key, hash|
        hash[key] = params[key]
      end
    end
  end
end
