source 'http://rubygems.org'

# Specify your gem's dependencies in meta-tags.gemspec
gemspec

gem 'actionpack', "~> #{ENV['RAILS_VERSION']}" if ENV['RAILS_VERSION']

group :test do
  # Lock rubocop to a specific version we use on CI. If you update this,
  # don't forget to switch rubocop channel in the .codeclimate.yml
  gem 'rubocop', '0.52.1'
  # We use this gem on CI to calculate code coverage.
  gem 'simplecov'
  gem 'rspec_junit_formatter'
end
