# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'meta_tags/version'

Gem::Specification.new do |spec|
  spec.name          = "meta-tags"
  spec.version       = MetaTags::VERSION
  spec.authors       = ["Dmytro Shteflyuk"]
  spec.email         = ["kpumuk@kpumuk.info"]

  spec.summary       = %q{Collection of SEO helpers for Ruby on Rails.}
  spec.description   = %q{Search Engine Optimization (SEO) plugin for Ruby on Rails applications.}
  spec.homepage      = "http://github.com/kpumuk/meta-tags"
  spec.license       = "MIT"
  spec.platform      = Gem::Platform::RUBY

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "actionpack", ">= 3.2.0", "< 5.2"

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5.0"
  spec.add_development_dependency "rspec-html-matchers", "~> 0.8.0"

  spec.cert_chain    = ["certs/kpumuk.pem"]
  spec.signing_key   = File.expand_path("~/.ssh/gem-kpumuk.pem") if $0 =~ /gem\z/
end
