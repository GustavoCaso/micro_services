module Services
  class TimeFrameCalculator
    def self.call
      now = Time.now
      check_time = now - ( 5 * 60 )
      [check_time.to_i, now.to_i]
    end
  end
end
