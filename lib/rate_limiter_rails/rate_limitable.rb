# frozen_string_literal: true

module RateLimiterRails
  module RateLimitable
    extend ActiveSupport::Concern

    included do
      before_action :rate_limit!
    end

    private

    #
    # Rate limit
    def rate_limit!
      # Fetch the rate limit settings for the current action
      action_config = RateLimiterRails.config.rate_limit_by_actions["#{controller_name}##{action_name}"]

      # If no specific config is found, use default limit and period
      action_config ||= { limit: RateLimiterRails.config.limit, period: RateLimiterRails.config.period }

      limiter = RateLimiter.new(
        redis_url: RateLimiterRails.config.redis_url,
        limit: action_config[:limit],
        period: action_config[:period]
      )

      key = limiter.key_for(request)

      # Check if the request is allowed
      render plain: "Rate limit exceeded", status: :too_many_requests unless limiter.allowed?(key)
    end
  end
end
