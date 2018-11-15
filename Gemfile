# frozen_string_literal: true

source 'http://rubygems.org'

# Specify your gem's dependencies in meta-tags.gemspec
gemspec

# Install specified version of actionpack if requested
gem 'actionpack', "~> #{ENV['RAILS_VERSION']}" if ENV['RAILS_VERSION']

group :test do
  # Lock rubocop to a specific version we use on CI. If you update this,
  # don't forget to switch rubocop channel in the .codeclimate.yml
  gem 'rubocop', '0.58.2'
  # We use this gem on CI to calculate code coverage.
  gem 'simplecov'
  # Format RSpec output for CircleCI
  gem 'rspec_junit_formatter'
end
