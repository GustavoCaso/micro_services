# frozen_string_literal: true

module Protocols
  class Http
    attr_reader :host, :http_client

    def initialize(data, http_client: HttpRequest.new)
      @host = data['host']
      @http_client = http_client
    end

    def call(app, keys_from_params)
      param_values = extract_params(app.params, keys_from_params)
      url = Hosts.new.match(host, param_values)
      result = http_client.get(url)
      return default_response if result.failure?
      [200, JSON.parse(result.value).to_json]
    rescue JSON::JSONError
      default_response
    end

    private

    def extract_params(params, keys_from_params)
      keys_from_params.each_with_object({}) do |key, hash|
        hash[key] = params[key]
      end
    end

    def default_response
      [500, {}.to_json]
    end
  end
end
