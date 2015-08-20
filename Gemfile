source 'http://rubygems.org'

# Specify your gem's dependencies in meta-tags.gemspec
gemspec

if ENV['RAILS_VERSION']
  gem 'actionpack', "~> #{ENV['RAILS_VERSION']}"
end

group :test do
  gem 'codeclimate-test-reporter', require: false
  gem 'rspec-html-matchers'
end
