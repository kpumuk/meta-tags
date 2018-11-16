# frozen_string_literal: true

source 'http://rubygems.org'

# Specify your gem's dependencies in meta-tags.gemspec
gemspec

if ENV['RAILS_VERSION']
  # Install specified version of actionpack if requested
  gem 'actionpack', "~> #{ENV['RAILS_VERSION']}"
end

group :test do
  # Lock rubocop to a specific version we use on CI. If you update this,
  # don't forget to switch rubocop channel in the .codeclimate.yml
  gem 'rubocop', '0.60.0'
  # Apply RSpec rubocop cops
  gem 'rubocop-rspec', require: false
  # We use this gem on CI to calculate code coverage.
  gem 'simplecov'
  # Format RSpec output for CircleCI
  gem 'rspec_junit_formatter'
end
