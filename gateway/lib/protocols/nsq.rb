#{"nsq"=>{"topic"=>"locations"}
require 'nsq'

module Protocols
  class Locations
    def self.call(params)
      longitude = params[:longitude]
      latitude = params[:latitude]
      drivers_id = params[:id]

      producer = ::Nsq::Producer.new(
        nsqd: '127.0.0.1:4150',
        topic: 'locations'
      )

      producer.write({ driver: drivers_id, coordinates: { longitude: longitude, latitude: latitude } }.to_json)
    end
  end

  class Nsq
    attr_reader :topic

    def initialize(data)
      @topic = data['topic']
    end

    def call(params)
      case topic
      when 'locations'
        Locations.call(params)
      end
    end
  end
end
