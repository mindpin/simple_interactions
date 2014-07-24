module SimpleInteractions
  module Helpers
    def request_interaction(user, client_id, data)
      message = Message.new(
        "user_id"   => user.id,
        "client_id" => client_id,
        "data"      => data
      )

      interactor.put("/users/#{user.id}", message)
    end

    def query_interaction(id)
      interactor.query(id)
    end

    protected

    def interactor
      @interactor ||= Interactor.new
    end
  end
end
