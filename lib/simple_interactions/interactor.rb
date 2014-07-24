module SimpleInteractions
  class Interactor
    delegate :conf, :to => SimpleInteractions
    
    def put(channel, message)
      header = {'Content-Type' =>'application/json'}
      req = Net::HTTP::Post.new(File.join(conf.path, channel), header)
      req.body = message.to_json
      res = Net::HTTP.new(conf.host, conf.port).start do |http|
        http.request(req)
      end
      JSON.parse(res.body)
    end

    def query(id)
      url = File.join(conf.server_url, "messages", id)
      JSON.parse(Net::HTTP.get(URI url))
    end
  end
end
