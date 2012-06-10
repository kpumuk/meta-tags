require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :test => :spec
task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new(:yard) do |t|
  t.options = ['--title', 'MetaTags Documentation']
  if ENV['PRIVATE']
    t.options.concat ['--protected', '--private']
  else
    t.options.concat ['--protected', '--no-private']
  end
end
