module SimpleInteractions
  class Adapter < Faye::RackAdapter
    TYPE_JSON   = {'Content-Type' => 'application/json; charset=utf-8'}
    QUERY_REGEX = /\/interactions\/messages\/([a-f0-9]{16})/
    PUT_REGEX   = /\/interactions\/users\/([0-9]+)/

    def handle_request(request)
      return query(request) if message_query?(request)
      return put(request)   if message_put?(request)
      super
    end

    private

    def message_query?(request)
      request.path.match(QUERY_REGEX) && request.get?
    end

    def query(request)
      id      = request.path.match(QUERY_REGEX)[1]
      message = Message.find(id)

      return ok_response(message.to_json) if message
      ok_response({:consumed => true}.to_json)
    end

    def message_put?(request)
      request.path.match(PUT_REGEX) &&
      request.post? &&
      request.content_type == "application/json"
    end

    def put(request)
      data    = JSON.parse(request.body.string)
      user_id = request.path.match(PUT_REGEX)[1]

      InvalidMessage.raise!("User not match!") {
        data["user_id"].to_s != user_id.to_s
      }

      message = Server.queue_manager.put(request.path, data)

      broadcast = {
        "interaction" => true,
        "channel"     => request.path,
        "data"        => message.to_h
      }

      EM.next_tick {@server.process(broadcast, nil) {}}

      ok_response({:server_id => message.server_id}.to_json)
    rescue InvalidMessage => ex
      error_response(400, ex.message)
    end

    def ok_response(res)
      [200, TYPE_JSON, res]
    end

    def error_response(status, msg)
      [status, TYPE_JSON, {:error => msg}.to_json]
    end
  end
end
