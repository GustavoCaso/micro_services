# frozen_string_literal: true
require 'json'

module Services
  module Redis
    class CoordinatesQuery
      attr_reader :redis, :time_frame_calculator

      def initialize(redis: REDIS, time_frame_calculator: TimeFrameCalculator)
        @redis = redis
        @time_frame_calculator = time_frame_calculator
      end

      def call(id)
        return unless id
        key = Keys::COORDINATES.call(id)
        min, max = time_frame_calculator.call
        result = redis.zrangebyscore(key, min, max)
        result.map { |r| JSON.parse(r) }
      end
    end
  end
end
