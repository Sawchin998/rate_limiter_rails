# frozen_string_literal: true

module RateLimiterRails
  module RateLimitable
    extend ActiveSupport::Concern

    #
    # Limits request rate based on config. controller and action
    #
    def rate_limit!(limit: nil, period: nil)
      config = RateLimiterRails.config
      limit ||= config.default_limit
      period ||= config.default_period

      limiter = RateLimiter.new(
        redis_url: config.redis_url,
        limit:,
        period:
      )

      key = limiter.key_for(request, controller_name:, action_name:)

      render plain: "Rate limit exceeded", status: :too_many_requests unless limiter.allowed?(key)
    rescue StandardError => e
      Rails.logger.error "Failed to limit request rates: #{e.message}"
      Rails.logger.error e
    end
  end
end
