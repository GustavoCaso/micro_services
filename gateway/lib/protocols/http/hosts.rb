module Protocols
  class Http
    class Hosts

      HOSTS = {
        'zombie-driver' => "http://#{ENV['ZOMBIE_DRIVER_DOMAIN']}:#{ENV['ZOMBIE_DRIVER_PORT']}/drivers/{id}"
      }

      attr_reader :hosts

      def initialize(hosts: HOSTS)
        @hosts = hosts
      end

      def match(host, params = {})
        host = hosts.fetch(host) { nil }
        return unless host
        host = subtitude_params(host, params)
        return if host.include?('{') ||  host.include?('}')
        host
      end

      private

      def subtitude_params(url, params)
        params.each do |key, value|
          url = url.sub("{#{key}}", value)
        end
        url
      end
    end
  end
end
