# RateLimiterRails

**RateLimiterRails** is a Ruby on Rails gem for limiting incoming requests to your application. It allows rate-limiting by default based on the client's IP address or authenticated user. The configuration is simple and flexible, making it easy to integrate into your Rails application.

## Installation

Add the gem to your Rails application's Gemfile using the GitHub repository link:

```ruby
gem 'rate_limiter_rails', git: 'https://github.com/Sawchin998/rate_limiter_rails'
```

Then run:

```bash
bundle install
```

## Configuration

To configure the gem, create an initializer file in your Rails application, e.g., `config/initializers/rate_limiter_rails.rb`, and define the following settings:

```ruby
RateLimiterRails.configure do |config|
  config.redis_url = "redis://localhost:6379/1" # Redis server URL default is `redis://localhost:6379/1`
  config.default_limit = 5                     # Default number of requests allowed
  config.default_period = 120                  # Default time period (in seconds)
end
```

## Usage

### Including the Module

To enable rate-limiting in a controller, include the `RateLimiterRails::RateLimitable` module:

```ruby
class ApplicationController < ActionController::Base
  include RateLimiterRails::RateLimitable
end
```

Alternatively, you can include it in specific controllers where you want to apply rate limits.

### Applying Rate Limits

Use the `rate_limit!` method in a `before_action` callback to define rate limits for specific actions. For example:

#### Rate-Limiting by IP Address

```ruby
class ExampleController < ApplicationController
  before_action -> { rate_limit!(limit: 5, period: 60) }, only: %i[show index]

  def show
    # Show action logic
  end

  def index
    # Index action logic
  end
end
```

In this example:
- The `show` and `index` actions are limited to 5 requests per 60 seconds.
- The rate-limiting is applied based on the client's IP address by default.

#### Rate-Limiting by User ID

If you need to rate-limit requests by a unique identifier like `id`, `uuid`, or `email` for the current user, use the `current_user_id` option:

```ruby
class ExampleController < ApplicationController
  before_action -> { rate_limit!(limit: 5, period: 60, current_user_id: current_user.id) }, only: %i[show index]

  def show
    # Show action logic
  end

  def index
    # Index action logic
  end
end
```

In this example, the rate-limiting is applied uniquely for each user based on their `id`.

#### Using Default Values

If no specific parameters are provided, the default values configured in the initializer will be used:

```ruby
class ExampleController < ApplicationController
  before_action :rate_limit!, only: %i[show index]

  def show
    # Show action logic
  end

  def index
    # Index action logic
  end
end
```

In this case:
- The `show` and `index` actions are rate-limited using the default limit and period specified in the initializer.
- The rate-limiting is applied based on the client's IP address by default.
