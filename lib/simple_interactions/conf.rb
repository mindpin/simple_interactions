module SimpleInteractions
  DEFAULTS = {
    :port => "9898",
    :path => "/interactions",
    :host => "localhost",
    :time => "32"
  }

  class Conf < Struct.new(:port, :path, :host, :time)
    alias :options :to_h

    def initialize(options={})
      DEFAULTS.merge(options).each do |(key, value)|
        next if !members.include?(key)
        send("#{key}=", value)
      end
    end

    def server_url
      base = "http://#{options[:host]}:#{options[:port]}"
      File.join(base, options[:path])
    end
  end

  class << self
    def conf
      @conf ||= Conf.new(load_yaml)
    end

    def load_yaml
      path = ["simple_interactions", "config/simple_interactions"].map do |name|
        ["yml", "yaml"].map {|ext| "./#{name}.#{ext}"}
      end.flatten.detect {|path| File.exists?(path)}

      path ? YAML.load_file(path) : {}
    end
  end
end
