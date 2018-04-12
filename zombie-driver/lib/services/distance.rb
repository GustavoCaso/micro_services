module Services
  class Distance
    include Result::Concern

    attr_reader :http_request, :comparator

    def initialize(http_request: Services::HttpRequest.new, comparator: Comparator)
      @http_request = http_request
      @comparator = comparator
    end

    def call(driver_id)
      result = http_request.get(locations_endpoint(driver_id))
      return failure(result.value) if result.failure?
      body = JSON.parse(result.value)
      comparator.new(body).call
    rescue JSON::JSONError => e
      failure(e.message)
    end

    private

    def locations_endpoint(driver_id)
      "http://#{ENV['LOCATION_DOMAIN']}:#{ENV['LOCATION_PORT']}/drivers/#{driver_id}/locations"
    end
  end
end
