module SimpleInteractions
  class Server
    attr_reader :options, :app

    delegate :conf, :to => SimpleInteractions

    def self.start
      self.current.start
    end

    def self.current
      @current = self.new
    end

    def self.queue_manager
      @queue_manager ||= QueueManager.new
    end

    def initialize
      @options = {
        :Host => conf.options[:host],
        :Port => conf.options[:port]
      }

      @app = Adapter.new(
        :mount   => conf.options[:path],
        :timeout => conf.options[:timeout]
      )

      app.add_extension(Consuming.new)

      ENV["SERVER_SIDE"] = "1"
    end

    def start
      Rack::Handler::Thin.run(app, options) do |thin|
        [:INT, :TERM].each do |sig|
          trap(sig) {thin.stop}
        end
      end
    end
  end
end
