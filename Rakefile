require 'rake'

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

begin
  require 'spec/rake/spectask'

  desc 'Default: run specs'
  task :default => :spec

  desc 'Test the sphinx plugin'
  Spec::Rake::SpecTask.new do |t|
    t.libs << 'lib'
    t.pattern = 'spec/*_spec.rb'
    t.verbose = true
    t.spec_opts = ['-cfs']
  end
rescue LoadError
  puts 'RSpec not available. Install it with: sudo gem install rspec'
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new(:yard) do |t|
    t.options = ['--title', 'MetaTags Documentation']
    if ENV['PRIVATE']
      t.options.concat ['--protected', '--private']
    else
      t.options.concat ['--protected', '--no-private']
    end
  end
rescue LoadError
  puts 'Yard not available. Install it with: sudo gem install yard'
end
