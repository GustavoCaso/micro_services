module Services
  module Redis
    class Keys
      COORDINATES = ->(id) { "drivers:coordinates:#{id}" }
    end
  end
end
