# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'meta_tags-rails/version'

Gem::Specification.new do |s|
  s.name        = 'meta_tags-rails'
  s.version     = MetaTags::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license     = "MIT"
  s.authors     = ['Dmytro Shteflyuk', 'Yves Siegrist']
  s.email       = ['Elektron1c97@gmail.com']
  s.homepage    = 'http://github.com/Elektron1c97/meta_tags-rails'
  s.summary     = %q{Collection of SEO helpers for Ruby on Rails.}
  s.description = %q{Search Engine Optimization (SEO) plugin for Ruby on Rails applications.}

  s.add_dependency 'actionpack', '>= 3.0.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.3.0'
  s.add_development_dependency 'rspec-html-matchers'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'bluecloth'

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files = ['README.md', 'CHANGELOG.md']
  s.rdoc_options     = ['--charset=UTF-8']
  s.require_paths    = ['lib']
end
