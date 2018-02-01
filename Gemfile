source 'http://rubygems.org'

# Specify your gem's dependencies in meta-tags.gemspec
gemspec

gem 'actionpack', "~> #{ENV['RAILS_VERSION']}" if ENV['RAILS_VERSION']

group :development do
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'simplecov'
end
