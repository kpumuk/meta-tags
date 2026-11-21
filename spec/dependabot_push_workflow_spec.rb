# frozen_string_literal: true

require "fileutils"
require "open3"
require "tmpdir"
require "yaml"

RSpec.describe "Dependabot Push workflow" do # rubocop:disable RSpec/DescribeClass
  workflow_path = File.expand_path("../.github/workflows/dependabot-push.yml", __dir__)
  step_name = "Commit regenerated lockfiles without checking out PR code"

  # Records every gh call and returns canned API responses, so the step runs
  # offline. The contents listing prints the PR's existing lockfile names.
  fake_gh = <<~'SH'
    #!/usr/bin/env bash
    echo "$*" >> "$GH_LOG"
    case "$*" in
      *"/contents/gemfiles"*) printf '%s\n' rails_7.2.gemfile.lock rails_8.0.gemfile.lock ;;
      *"/git/blobs"*) echo blob-sha ;;
      *"/git/commits/"*) echo base-tree-sha ;;
      *"/git/trees"*) echo new-tree-sha ;;
      *"/git/commits"*) echo new-commit-sha ;;
    esac
  SH

  def run_step(script, fake_gh, artifact_names)
    Dir.mktmpdir do |dir|
      bin = File.join(dir, "bin")
      lock_dir = File.join(dir, "dependabot-lockfiles")
      FileUtils.mkdir_p([bin, lock_dir])
      File.write(File.join(bin, "gh"), fake_gh)
      File.chmod(0o755, File.join(bin, "gh"))
      artifact_names.each { |name| File.write(File.join(lock_dir, name), "GEM\n") }
      log = File.join(dir, "gh.log")
      File.write(log, "")

      env = {
        "PATH" => "#{bin}:#{ENV.fetch("PATH")}",
        "RUNNER_TEMP" => dir,
        "GH_LOG" => log,
        "GITHUB_REPOSITORY" => "kpumuk/meta-tags",
        "EXPECTED_HEAD_SHA" => "head-sha",
        "HEAD_SHA" => "head-sha",
        "HEAD_REF" => "dependabot/bundler/rails"
      }
      _, stderr, status = Open3.capture3(env, "bash", "--noprofile", "--norc", "-eo", "pipefail", "-c", script)
      tree = File.exist?(File.join(dir, "tree.json")) ? File.read(File.join(dir, "tree.json")) : ""
      {status: status, stderr: stderr, writes: File.readlines(log).grep(/--method/), tree: tree}
    end
  end

  let(:script) do
    steps = YAML.safe_load_file(workflow_path).dig("jobs", "push", "steps")
    steps.find { |step| step["name"] == step_name }.fetch("run")
  end

  it "commits lockfiles that already exist in the pull request" do
    result = run_step(script, fake_gh, ["rails_8.0.gemfile.lock"])

    expect(result[:status]).to be_success
    expect(result[:tree]).to include("gemfiles/rails_8.0.gemfile.lock")
    expect(result[:writes].last).to include("git/refs/heads/dependabot%2Fbundler%2Frails")
  end

  ["-ve.lock", "-vexploit.gemfile.lock", "rails_9.0.gemfile.lock"].each do |name|
    it "refuses the unlisted artifact #{name} before writing anything" do
      result = run_step(script, fake_gh, [name])

      expect(result[:status]).not_to be_success
      expect(result[:stderr]).to include("Refusing to modify unexpected lockfile: #{name}")
      expect(result[:writes]).to be_empty
    end
  end
end
