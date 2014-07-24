module SimpleInteractions
  class QueueManager
    def put(channel, data)
      InvalidMessage.raise!("Duplicated client_id!") do
        already_requested?(data)
      end

      Message.new(data).save
    end

    def find(id)
      Message.find(id)
    end

    private

    def already_requested?(data)
      !!Message.find_by(:client_id, data["client_id"])
    end
  end
end
