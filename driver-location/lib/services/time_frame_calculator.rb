module Services
  class TimeFrameCalculator
    VALID_KEYS = %w[minutes hours days]
    MINUTES_IN_SECONDS = 60
    HOURS_IN_SECONDS = 60 * 60
    DAYS_IN_SECONDS = 24 * 60 * 60

    def call(params = {})
      return default_time_frame unless params.keys.any? { |key| VALID_KEYS.include?(key) }

      total_to_rest = calculate_total_time(params)

      return_epoch_times(total_to_rest)
    end

    private

    def calculate_total_time(params)
      total = 0
      params.each do |key, value|
        total += send(key.to_sym, value.to_i)
      end
      total
    end

    def minutes(value)
      (value * MINUTES_IN_SECONDS)
    end

    def hours(value)
      (value * HOURS_IN_SECONDS)
    end

    def days(value)
      (value * DAYS_IN_SECONDS)
    end

    # Default time range of 5 minutes
    def default_time_frame
      return_epoch_times(minutes(5))
    end

    def return_epoch_times(value)
      now = Time.now
      check_time = now - value
      [check_time.to_i, now.to_i]
    end
  end
end
