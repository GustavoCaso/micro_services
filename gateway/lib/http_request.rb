# frozen_string_literal: true
require 'net/https'

class HttpRequest
  class << self
    def get(url)
      uri = URI.parse(url)
      request = Net::HTTP::Get.new(uri.request_uri)
      yield request if block_given?

      http(uri).request(request)
    end

    def post(url, **params)
      uri = URI.parse(url)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data(params)
      yield request if block_given?

      http(uri).request(request)
    end

    private

    def http(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http
    end
  end
end
