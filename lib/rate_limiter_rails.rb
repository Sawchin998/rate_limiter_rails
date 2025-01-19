# frozen_string_literal: true

require "redis"
require_relative "rate_limiter_rails/version"
require_relative "rate_limiter_rails/rate_limiter"
require_relative "rate_limiter_rails/rate_limitable"

# RateLimiterRails
module RateLimiterRails
  class Error < StandardError; end

  class << self
    attr_accessor :config

    def configure
      @config ||= Configuration.new
      yield(@config) if block_given?
    end
  end

  # Configuration
  class Configuration
    attr_accessor :redis_url, :default_limit, :default_period, :rate_limit_by_actions

    def initialize
      @redis_url = "redis://localhost:6379/1"
      @default_limit = 100
      @default_period = 120 # in seconds
    end
  end
end
