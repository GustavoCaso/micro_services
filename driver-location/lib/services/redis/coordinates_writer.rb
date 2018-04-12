# frozen_string_literal: true

require 'json'

module Services
  module Redis
    class CoordinatesWriter
      attr_reader :redis

      def initialize(redis: ::REDIS)
        @redis = redis
      end

      def call(message, updated_at)
        return unless enough_information?(message)
        return unless updated_at.is_a?(Time)
        return unless valid_coordinates?(message['coordinates'])
        score = updated_at.to_i
        key = Keys::COORDINATES.call(message['driver'])
        data = message['coordinates'].merge('updated_at' => updated_at.to_s)
        redis.zadd(key, score, data.to_json)
      end

      private

      def enough_information?(message)
        (message['driver'] && !message['driver'].empty?) &&
          (message['coordinates'] && !message['coordinates'].empty?)
      end

      def valid_coordinates?(coordinates)
        valid_latitude?(coordinates['latitude'].to_f) &&
          valid_longitude?(coordinates['longitude'].to_f)
      end

      def valid_latitude?(latitude)
        latitude <= 90 && latitude >= -90
      end

      def valid_longitude?(longitude)
        longitude <= 180 && longitude >= -180
      end
    end
  end
end
