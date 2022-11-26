# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in meta-tags.gemspec
gemspec

if ENV["RAILS_VERSION"]
  # Install specified version of actionpack if requested
  gem "railties", "~> #{ENV["RAILS_VERSION"]}"
end

unless ENV["NO_STEEP"] == "1"
  # Ruby typings
  gem "steep", "~> 1.1.1", platform: :mri
end

group :test do
  # Ruby Style Guide, with linter & automatic code fixer
  gem "standard"
  # Cops for rails apps
  gem "rubocop-rails"
  # Cops for rake tasks
  gem "rubocop-rake"
  # Apply RSpec rubocop cops
  gem "rubocop-rspec", require: false
  # We use this gem on CI to calculate code coverage.
  gem "simplecov", "~> 0.21.2"
  # Format RSpec output for CircleCI
  gem "rspec_junit_formatter"
end
