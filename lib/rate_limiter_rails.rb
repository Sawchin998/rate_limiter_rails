# frozen_string_literal: true

require "redis"
require_relative "rate_limiter_rails/version"

# RateLimiterRails
module RateLimiterRails
  class Error < StandardError; end

  class << self
    attr_accessor :config

    def configure
      @config ||= Configuration.new
      yield(config) if block_given?
    end
  end

  # Configuration
  class Configuration
    attr_accessor :redis_url, :limit, :period

    def initialize
      @redis_url = "redis://localhost:6379/1"
      @limit = 100
      @period = 120 # in seconds
    end
  end
end
