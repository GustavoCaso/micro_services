module Services
  class Distance
    class Comparator

      extend Result::Concern

      class Coordinate
        attr_reader :latitude, :longitude
        def initialize(latitude, longitude)
          @latitude = latitude.to_f
          @longitude = longitude.to_f
        end
      end

      private_constant :Coordinate

      RAD_PER_DEG = Math::PI/180  # PI / 180
      RADIUS_KM = 6371            # Earth radius in kilometers
      RADIUS_M = RADIUS_KM * 1000 # Radius in meters

      class << self
        # https://stackoverflow.com/a/12969617
        def call(point_1, point_2)
          coordinate_1 = extract_coordinate(point_1)
          coordinate_2 = extract_coordinate(point_2)

          return failure('Missing Coordinates') unless coordinate_1 && coordinate_2

          # Delta, converted to rad
          dlat_rad = (coordinate_2.latitude - coordinate_1.latitude) * RAD_PER_DEG
          dlon_rad = (coordinate_2.longitude - coordinate_1.longitude) * RAD_PER_DEG

          # Convert to radious
          lat1_rad, lat2_rad = [coordinate_1.latitude, coordinate_2.latitude].map { |i| i * RAD_PER_DEG }
          lon1_rad, lon2_rad = [coordinate_1.longitude, coordinate_2.longitude].map { |i| i * RAD_PER_DEG }

          a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2

          c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

          success(RADIUS_M * c) # Delta in meters
        end

        private

        def extract_coordinate(point)
          return unless point['longitude'] && point['latitude']
          Coordinate.new(point['latitude'], point['longitude'])
        end
      end
    end
  end
end
