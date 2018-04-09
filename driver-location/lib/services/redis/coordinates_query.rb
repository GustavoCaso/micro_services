# frozen_string_literal: true
require 'json'

module Services
  module Redis
    class CoordinatesQuery
      include Result::Concern

      attr_reader :redis, :time_frame_calculator

      def initialize(redis: REDIS, time_frame_calculator: TimeFrameCalculator.new)
        @redis = redis
        @time_frame_calculator = time_frame_calculator
      end

      def call(params)
        id = params[:id]
        rest_params = params.reject { |k, _| k == :id }
        return failure('Missing ID') unless id
        key = Keys::COORDINATES.call(id)
        min, max = time_frame_calculator.call(rest_params)
        result = redis.zrangebyscore(key, min, max)
        success(result.map { |r| JSON.parse(r) })
      rescue JSON::JSONError => e
        failure(e.message)
      end
    end
  end
end
