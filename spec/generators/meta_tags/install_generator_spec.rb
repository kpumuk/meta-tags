# frozen_string_literal: true

require "fileutils"
require "rails/generators"
require "tmpdir"
require "generators/meta_tags/install_generator"

RSpec.describe MetaTags::Generators::InstallGenerator do
  let(:destination_root) { Dir.mktmpdir }

  after do
    FileUtils.remove_entry(destination_root) if File.exist?(destination_root)
  end

  it "copies the initializer template" do
    described_class.start([], destination_root: destination_root)

    generated_file = File.join(destination_root, "config/initializers/meta_tags.rb")
    template_file = File.join(described_class.source_root, "config/initializers/meta_tags.rb")

    expect(File).to exist(generated_file)
    expect(File.read(generated_file)).to eq(File.read(template_file))
  end
end
