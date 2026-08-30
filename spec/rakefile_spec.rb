# frozen_string_literal: true

require "rake"

load File.expand_path("../Rakefile", __dir__)

RSpec.describe SteepRunner do
  it "fails when Steep returns a nonzero status" do
    allow(described_class).to receive(:run).with("check").and_return(1)

    expect { Rake::Task["steep"].invoke }
      .to raise_error(RuntimeError, "Steep exited with status 1")
  end
end
