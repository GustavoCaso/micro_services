# frozen_string_literal: true
require 'net/https'

class HttpRequest
  include Result::Concern

  def get(url)
    return failure('No url provided') unless url
    uri = URI.parse(url)
    request = Net::HTTP::Get.new(uri.request_uri)
    yield request if block_given?

    response = http(uri).request(request)
    return failure('Invalid request') unless response.is_a?(Net::HTTPSuccess)
    success(response.body)
  rescue Errno::ECONNREFUSED => e
    failure(e.message)
  end

  private

  def http(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http
  end
end

