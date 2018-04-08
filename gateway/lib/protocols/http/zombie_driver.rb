# frozen_string_literal: true
require_relative 'base'

module Protocols
  class Http
    class ZombieDriver < Base
      def call(params)
        driver_id = params[:id]
        return default_response unless driver_id
        result = http_client.get("http://localhost:4001/drivers/#{driver_id}")
        return default_response if result.failure?
        JSON.parse(result.value).to_json
      end

      def default_response
        {}.to_json
      end
    end
  end
end
