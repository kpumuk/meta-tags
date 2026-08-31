# frozen_string_literal: true

require "spec_helper"

RSpec.describe MetaTags::MetaTagsCollection do
  subject(:collection) { described_class.new }

  describe "#page_title" do
    it "excludes a site supplied through defaults" do
      defaults = {site: "Default Site", title: "Default Page"}

      expect(collection.page_title(defaults)).to eq("Default Page")
      expect(collection.full_title(defaults)).to eq("Default Site | Default Page")
    end

    it "uses stored site and title values ahead of defaults" do
      collection.update(site: "Stored Site", title: "Stored Page")
      defaults = {site: "Default Site", title: "Default Page"}

      expect(collection.page_title(defaults)).to eq("Stored Page")
      expect(collection.full_title(defaults)).to eq("Stored Site | Stored Page")
    end

    it "combines stored and default values by precedence" do
      collection.update(site: "Stored Site")
      defaults = {site: "Default Site", title: "Default Page"}

      expect(collection.page_title(defaults)).to eq("Default Page")
      expect(collection.full_title(defaults)).to eq("Stored Site | Default Page")

      collection = described_class.new
      collection.update(title: "Stored Page")

      expect(collection.page_title(defaults)).to eq("Stored Page")
      expect(collection.full_title(defaults)).to eq("Default Site | Stored Page")
    end

    it "falls back to the effective site when the page title is empty" do
      collection.update(site: "Stored Site", title: "")

      expect(collection.page_title(site: "Default Site", title: "Default Page")).to eq("Stored Site")
      expect(described_class.new.page_title(site: "Default Site", title: "")).to eq("Default Site")
    end

    it "applies reverse ordering and custom separators without including the site" do
      defaults = {
        site: "Default Site",
        title: ["First", "Second"],
        separator: ":",
        prefix: " -",
        suffix: "+ ",
        reverse: true
      }

      expect(collection.page_title(defaults)).to eq("Second -:+ First")
    end

    it "restores the collection after repeated calls and exceptions" do
      collection.update(site: "Stored Site", title: "Stored Page", separator: "/")
      original_meta_tags = collection.meta_tags
      original_values = original_meta_tags.deep_dup

      expect(collection.page_title(site: "Default Site")).to eq("Stored Page")
      expect(collection.page_title(site: "Default Site")).to eq("Stored Page")
      expect(collection.meta_tags).to be(original_meta_tags)
      expect(collection.meta_tags).to eq(original_values)

      allow(MetaTags::TextNormalizer).to receive(:normalize_title).and_raise("normalization failed")

      expect {
        collection.page_title(site: "Default Site", title: "Default Page")
      }.to raise_error("normalization failed")
      expect(collection.meta_tags).to be(original_meta_tags)
      expect(collection.meta_tags).to eq(original_values)
    end
  end
end
