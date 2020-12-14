# frozen_string_literal: true

require "spec_helper"

describe MetaTags::ViewHelper, "displaying robots meta tags" do
  it "displays meta tags specified with :robots" do
    subject.display_meta_tags(robots: { "max-snippet": -1 }).tap do |meta|
      expect(meta).to have_tag("meta", with: { content: "max-snippet:-1", name: "robots" })
    end
  end

  it "displays multiple custom robots tags in an array" do
    subject.display_meta_tags(robots: { "max-snippet": -1, "max-video-preview": -1 }).tap do |meta|
      expect(meta).to have_tag("meta", with: { content: "max-snippet:-1, max-video-preview:-1", name: "robots" })
    end
  end

  it "displays custom robots tags alng with noindex" do
    subject.noindex(true)
    subject.display_meta_tags(robots: { "max-snippet": -1, "max-video-preview": -1 }).tap do |meta|
      expect(meta).to have_tag("meta", with: { content: "noindex, max-snippet:-1, max-video-preview:-1", name: "robots" })
    end
  end
end
