# frozen_string_literal: true
require_relative 'http/zombie_driver'

module Protocols
  class Http
    attr_reader :host

    def initialize(data)
      @host = data['host']
    end

    def call(params)
      case host
      when 'zombie-driver'
        ZombieDriver.new.call(params)
      end
    end
  end
end
