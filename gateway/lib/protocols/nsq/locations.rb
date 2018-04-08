# frozen_string_literal: true
require 'nsq'

module Protocols
  class Nsq
    class Locations
      TOPIC_NAME = 'locations'.freeze
      NSQD = '127.0.0.1:4150'.freeze

      attr_reader :longitude, :latitude, :driver_id, :producer

      def initialize(params, producer: ::Nsq::Producer)
        @longitude = params[:longitude]
        @latitude = params[:latitude]
        @driver_id = params[:id]
        @producer = producer
      end

      def call
        return unless longitude && latitude && driver_id
        nsq_producer = producer.new(
          nsqd: '127.0.0.1:4150',
          topic: TOPIC_NAME
        )

        nsq_producer.write(locations_message)
        nsq_producer.terminate
      end

      private

      def locations_message
        { driver: driver_id, coordinates: { longitude: longitude, latitude: latitude } }.to_json
      end
    end
  end
end
