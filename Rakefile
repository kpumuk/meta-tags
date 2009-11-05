require 'rake'
require 'spec/rake/spectask'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name        = 'meta-tags'
    gemspec.summary     = 'Collection of SEO helpers for Ruby on Rails'
    gemspec.description = 'Search Engine Optimization (SEO) plugin for Ruby on Rails applications.'
    gemspec.email       = 'kpumuk@kpumuk.info'
    gemspec.homepage    = 'http://github.com/kpumuk/meta-tags'
    gemspec.authors     = ['Dmytro Shteflyuk']
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts 'Jeweler not available. Install it with: sudo gem install jeweler'
end

desc 'Default: run unit tests.'
task :default => :spec

desc 'Test the meta-tags plugin.'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.libs << 'lib'
  t.pattern = 'spec/**/*_spec.rb'
  t.verbose = true
  t.spec_opts = ['-cfs']
end

desc 'Generate documentation for the meta-tags plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'MetaTags'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
