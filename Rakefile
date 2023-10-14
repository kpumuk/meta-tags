# frozen_string_literal: true

require "bundler"
Bundler::GemHelper.install_tasks

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

desc "Run RSpec tests"
task test: :spec
task default: :spec

module SteepRunner
  def self.run(*command)
    require "steep"
    require "steep/cli"

    Steep::CLI.new(argv: command, stdout: $stdout, stderr: $stderr, stdin: $stdin).run
  end
end

desc "Check type information"
task steep: "steep:check"

namespace :steep do
  desc "Check type information"
  task :check do
    SteepRunner.run("check")
  end

  desc "Print type statistics"
  task :stats do
    SteepRunner.run("stats", "--log-level=fatal")
  end
end

namespace :rbs do
  desc "Run RSpec tests with RBS enabled to test type signatures"
  task :spec do
    exec(
      {
        "RBS_TEST_TARGET" => "MetaTags::*",
        "RUBYOPT" => "-rrbs/test/setup"
      },
      "bundle exec rspec"
    )
  end
end
