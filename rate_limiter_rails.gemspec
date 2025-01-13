# frozen_string_literal: true

require_relative "lib/rate_limiter_rails/version"

Gem::Specification.new do |spec|
  spec.name = "rate_limiter_rails"
  spec.version = RateLimiterRails::VERSION
  spec.authors = ["Sachin Maharjan"]
  spec.email = ["sachin9860810@gmail.com"]

  spec.summary = "Rate limiter gem for rails using redis."
  spec.description = "This gem provided rails limit for individual actions in rails controllers"
  spec.homepage = "https://github.com/Sawchin998/rate_limiter_rails.git"
  spec.required_ruby_version = ">= 3.2.2"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "railties", "~> 7.0", ">= 7.0.8"
  spec.add_dependency "redis", "~> 5.3"

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
