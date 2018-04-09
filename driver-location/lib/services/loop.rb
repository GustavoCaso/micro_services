module Services
  module Loop
    def self.call
      listener = Listener.new
      loop do
        listener.call
      end
    end
  end
end
