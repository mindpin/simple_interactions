module SimpleInteractions
  class Message < Struct.new(:client_id, :user_id, :data, :server_id, :consumed)
    def self.find(id)
      if ENV["SERVER_SIDE"]
        result = RedisPool.get(:message, id)
        return if result.empty?
        self.new(result)
      end
    end

    def self.find_by(field, value)
      if ENV["SERVER_SIDE"]
        result = RedisPool.get_by(:message, field, value)
        return if result.nil?
        self.new(result)
      end
    end

    def initialize(options = {})
      InvalidMessage.raise! do
        !(options["user_id"] && options["client_id"] && options["data"])
      end

      self[:client_id] = options["client_id"]
      self[:user_id]   = options["user_id"]
      self[:data]      = options["data"]

      if ENV["SERVER_SIDE"]
        self[:server_id] = options["server_id"] || SecureRandom.hex(8)
        self[:consumed]  = options["consumed"]  || false
      end
    rescue NoMethodError => ex
      InvalidMessage.raise!
    end

    def save
      if ENV["SERVER_SIDE"]
        result = RedisPool.put(:message, server_id, self.to_h) == "OK" ? self : nil
        result.try(:index!)
        result
      end
    end

    def consume!
      self[:consumed] = true

      if ENV["SERVER_SIDE"]
        self.save.try(:expire!)
      end

      consumed?
    end

    def index!
      RedisPool.index(:message, :client_id, client_id, server_id)
    end

    def expire!
      RedisPool.expire(:idx, "message:client_id:#{client_id}", at: 4.minutes.from_now)
      RedisPool.expire(:message, server_id, at: 4.minutes.from_now)
    end

    def consumed?
      consumed
    end
  end
end
