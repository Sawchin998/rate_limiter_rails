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

    def key_for(request, current_user_id: nil, controller_name: nil, action_name: nil)
      key = "rate_limiter:#{controller_name}:#{action_name}"

      return "#{key}:ip:#{request.ip}" unless current_user_id.present?

      "#{key}:user:#{current_user_id}"
    end
  end
end
