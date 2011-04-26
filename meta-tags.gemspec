# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'meta_tags/version'

Gem::Specification.new do |s|
  s.name        = 'meta-tags'
  s.version     = MetaTags::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Dmytro Shteflyuk']
  s.email       = ['kpumuk@kpumuk.info']
  s.homepage    = 'http://github.com/kpumuk/meta-tags'
  s.summary     = %q{Collection of SEO helpers for Ruby on Rails.}
  s.description = %q{Search Engine Optimization (SEO) plugin for Ruby on Rails applications.}

  s.add_dependency 'actionpack'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'yard'

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files = ['README.rdoc']
  s.rdoc_options     = ['--charset=UTF-8']
  s.require_paths    = ['lib']
end
