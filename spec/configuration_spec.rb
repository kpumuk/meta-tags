# frozen_string_literal: true

require "spec_helper"

RSpec.describe MetaTags::Configuration do
  it "is returned by MetaTags.config" do
    expect(MetaTags.config).to be_instance_of(described_class)
  end

  it "is yielded by MetaTags.configure" do
    MetaTags.configure do |c|
      expect(c).to be_instance_of(described_class)
      expect(c).to be(MetaTags.config)
    end
  end

  it "accepts Rails tag option values for title tag attributes" do
    attributes = {
      class: ["page", ["permanent", {highlighted: true}]],
      data: {page_id: 123, rating: 4.5, visible: false},
      hidden: true
    }

    MetaTags.config.title_tag_attributes = attributes

    expect(MetaTags.config.title_tag_attributes).to eq(attributes)
  end

  it "disables symbolic references in Array values by default" do
    config = described_class.new

    expect(config.resolve_symbolic_references_in_arrays).to be(false)

    config.resolve_symbolic_references_in_arrays = true
    config.reset_defaults!

    expect(config.resolve_symbolic_references_in_arrays).to be(false)
  end
end
