# frozen_string_literal: true

module RateLimiterRails
  # RateLimiter
  class RateLimiter
    def initialize(redis_url:, limit:, period:)
      @redis = Redis.new(url: redis_url)
      @limit = limit
      @period = period
    end

    def allowed?(key)
      current_time = Time.now.to_i
      pipeline = @redis.pipelined do
        @redis.zremrangebyscore(key, 0, current_time - @period)
        @redis.zadd(key, current_time, current_time)
        @redis.zcount(key, "-inf", "+inf")
      end
      count = pipeline[2]
      @redis.expire(key, @period)
      count <= @limit
    end

    def key_for(request)
      "rate_limiter:ip:#{request.env['rate_limiter_rails.ip']}"
    end
  end
end
