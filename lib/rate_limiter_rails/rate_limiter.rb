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
      @redis.pipelined do
        @redis.zremrangebyscore(key, 0, current_time - @period)
        @redis.zadd(key, current_time, current_time)
      end

      count = @redis.zcount(key, "-inf", "+inf")
      @redis.expire(key, @period)
      count <= @limit
    end

    def key_for(request, controller_name, action_name)
      "rate_limiter:ip:#{request.ip}:#{controller_name}:#{action_name}"
    end
  end
end
