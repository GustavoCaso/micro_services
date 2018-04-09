# frozen_string_literal: true
require_relative 'base'

module Protocols
  class Http
    class ZombieDriver < Base
      def call(params)
        driver_id = params[:id]
        return default_response unless driver_id
        result = http_client.get(zombie_driver_url(driver_id))
        return default_response if result.failure?
        [200, JSON.parse(result.value).to_json]
      end

      private

      def zombie_driver_url(driver_id)
        "http://#{ENV['ZOMBIE_DRIVER_DOMAIN']}:#{ENV['ZOMBIE_DRIVER_PORT']}/drivers/#{driver_id}"
      end

      def default_response
        [500, {}.to_json]
      end
    end
  end
end
