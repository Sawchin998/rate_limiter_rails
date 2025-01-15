# frozen_string_literal: true

require "rails/railtie"

module RateLimiterRails
  # railtie
  class Railtie < Rails::Railtie
    initializer "rate_limiter_rails.add_middleware" do |app|
      app.middleware.use Middleware
    end
  end

  # middleware
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      env["rate_limiter_rails.ip"] = request.ip
      @app.call(env)
    end
  end
end
