class Result
  attr_reader :value

  def initialize(value)
    @value = value
  end

  class Success < Result
    def success?
      true
    end

    def failure?
      false
    end
  end

  class Failure < Result
    def success?
      false
    end

    def failure?
      true
    end
  end

  module Concern
    def success(value)
      Result::Success.new(value)
    end

    def failure(value)
      Result::Failure.new(value)
    end
  end
end
