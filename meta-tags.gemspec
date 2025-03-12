# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "meta_tags/version"

Gem::Specification.new do |spec|
  spec.name = "meta-tags"
  spec.version = MetaTags::VERSION
  spec.authors = ["Dmytro Shteflyuk"]
  spec.email = ["kpumuk@kpumuk.info"]

  spec.summary = "Collection of SEO helpers for Ruby on Rails."
  spec.description = "Search Engine Optimization (SEO) plugin for Ruby on Rails applications."
  spec.homepage = "https://github.com/kpumuk/meta-tags"
  spec.license = "MIT"
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = ">= 3.0.0"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(\.|Gemfile|Appraisals|Steepfile|Rakefile|meta-tags.gemspec|(bin|spec|gemfiles)/)})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "actionpack", ">= 6.0.0", "< 8.1"

  spec.add_development_dependency "appraisal", "~> 2.5.0"
  spec.add_development_dependency "railties", ">= 3.2.0", "< 8.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.13.0"
  spec.add_development_dependency "rspec-html-matchers", "~> 0.10.0"
  spec.add_development_dependency "simplecov", "~> 0.22.0"
  # Code style
  spec.add_development_dependency "rubocop-rails", "~> 2.28.0"
  spec.add_development_dependency "rubocop-rake", "~> 0.7.1"
  spec.add_development_dependency "rubocop-rspec", "~> 3.4.0"
  spec.add_development_dependency "standard", "~> 1.31"
  # Format RSpec output for CircleCI
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.6.0"

  spec.cert_chain = ["certs/kpumuk.pem"]
  spec.signing_key = File.expand_path("~/.gem/gem-private_key.pem") if $PROGRAM_NAME.end_with?("gem")

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/kpumuk/meta-tags/issues/",
    "changelog_uri" => "https://github.com/kpumuk/meta-tags/blob/main/CHANGELOG.md",
    "documentation_uri" => "https://rubydoc.info/github/kpumuk/meta-tags/",
    "homepage_uri" => "https://github.com/kpumuk/meta-tags/",
    "source_code_uri" => "https://github.com/kpumuk/meta-tags/",
    "rubygems_mfa_required" => "true"
  }
end
