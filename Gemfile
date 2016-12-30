source 'http://rubygems.org'

# Specify your gem's dependencies in meta-tags.gemspec
gemspec

if ENV['RAILS_VERSION']
  gem 'actionpack', "~> #{ENV['RAILS_VERSION']}"
end

if RUBY_VERSION =~ /^2\.0\./
  gem 'nokogiri', '~> 1.6.8.1'
end

group :test do
  gem 'simplecov'
  gem 'codeclimate-test-reporter', '~> 1.0.0'
end
