module SimpleInteractions
  class Consuming
    def incoming(message, callback)
      with_consuming(message) do |msg|
        msg ? msg.consume! : message["error"] = "Message not found!"
      end

      callback.call(message)
    end

    def with_consuming(message, &block)
      if message["channel"] == "/messages/consuming"
        msg = Message.find(message["data"]["server_id"])
        block.call(msg)
      end
    end
  end
end
