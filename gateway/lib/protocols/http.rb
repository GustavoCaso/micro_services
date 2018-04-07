require_relative '../http_request'

module Protocols
  class ZombieDriver
    def self.call(params)
      driver_id = params[:id]
      response = HttpRequest.get("http://localhost:4001/drivers/#{driver_id}")
      JSON.parse(response.body).to_json
    end
  end

  class Http
    attr_reader :host

    def initialize(data)
      @host = data['host']
    end

    def call(params)
      case host
      when 'zombie-driver'
        ZombieDriver.call(params)
      end
    end
  end
end
