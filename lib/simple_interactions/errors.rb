module SimpleInteractions
  class Error < Exception
    def self.raise!(msg = nil, &cond)
      raise self.new(msg) if !cond || cond.call
    end
  end

  InvalidMessage = Class.new(Error)
end
