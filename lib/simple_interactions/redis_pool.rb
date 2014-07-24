module SimpleInteractions
  module RedisPool
    class << self
      def with(&block)
        pool.with(&block)
      end

      def put(type, id, fields = {})
        self.with do |r|
          r.hmset(tid(type, id), *fields.to_a.flatten)
        end
      end

      def get(type, id)
        self.with do |r|
          r.hgetall(tid(type, id))
        end
      end

      def get_by(type, field, value)
        idx = self.with do |r|
          r.get(tindex(type, field, value))
        end

        return if !idx

        id = idx.split(":").last

        self.get(type, id)
      end

      def index(type, field, value, id)
        self.with do |r|
          r.set(tindex(type, field, value), id)
        end
      end

      def expire(type, id, at: Time.now)
        self.with do |r|
          r.expireat(tid(type, id), at.to_i)
        end
      end

      private

      def tid(type, id)
        "#{type}:#{id}"
      end

      def tindex(type, field, value)
        "idx:#{type}:#{field}:#{value}"
      end

      def pool
        @pool ||= ConnectionPool.new(size: 8, timeout: 8) do
          Redis.new(:driver => :hiredis)
        end
      end
    end
  end
end
