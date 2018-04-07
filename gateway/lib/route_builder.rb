# Example routes
# {"path"=>"/drivers/:id/locations", "method"=>"PATCH", "nsq"=>{"topic"=>"locations"}},
# {"path"=>"/drivers/:id", "method"=>"GET", "http"=>{"host"=>"zombie-driver"}}

require_relative 'protocols'

class RouteBuilder
  ProtocolNotImplemented = Class.new(StandardError)

  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(url)
    method = url['method'].downcase
    path = url['path']

    protocol_builder = extract_protocol_builder(url)
    return unless protocol_builder && method && path

    app.send(method.to_sym, path) do
      protocol_builder.call(params)
    end
  end

  private

  def extract_protocol_builder(url)
    case url
    when http?
      Protocols::Http.new(url['http'])
    when nsq?
      Protocols::Nsq.new(url['nsq'])
    end
  end

  def http?
    ->(hash) { hash.has_key?('http') }
  end

  def nsq?
    ->(hash) { hash.has_key?('nsq') }
  end
end
