module Protocols
  class Http
    class Base
      attr_reader :http_client

      def initialize(http_client: HttpRequest.new)
        @http_client = http_client
      end
    end
  end
end
