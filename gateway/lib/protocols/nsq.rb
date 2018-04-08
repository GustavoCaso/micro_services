# frozen_string_literal: true
require_relative 'nsq/locations'

module Protocols
  class Nsq
    attr_reader :topic

    def initialize(data)
      @topic = data['topic']
    end

    def call(params)
      case topic
      when 'locations'
        Locations.new(params).call
      end
    end
  end
end
