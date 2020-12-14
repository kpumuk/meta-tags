# frozen_string_literal: true

require "spec_helper"

RSpec.describe MetaTags::ViewHelper, "displaying robots meta tags" do
  it "displays meta tags specified with :robots" do
    subject.display_meta_tags(robots: {"max-snippet": -1}).tap do |meta|
      expect(meta).to have_tag("meta", with: {content: "max-snippet:-1", name: "robots"})
    end
  end

  it "displays meta tags specified with :googlebot" do
    subject.display_meta_tags(googlebot: {unavailable_after: "2020-09-21"}).tap do |meta|
      expect(meta).to have_tag("meta", with: {content: "unavailable_after:2020-09-21", name: "googlebot"})
    end
  end

  it "displays meta tags specified with :bingbot" do
    subject.display_meta_tags(bingbot: {"max-image-preview": "large"}).tap do |meta|
      expect(meta).to have_tag("meta", with: {content: "max-image-preview:large", name: "bingbot"})
    end
  end

  it "displays multiple custom robots tags in a hash" do
    subject.display_meta_tags(robots: {"max-snippet": -1, "max-video-preview": -1}).tap do |meta|
      expect(meta).to have_tag("meta", with: {content: "max-snippet:-1, max-video-preview:-1", name: "robots"})
    end
  end

  it "displays custom robots tags along with noindex" do
    subject.noindex(true)
    subject.display_meta_tags(robots: {"max-snippet": -1, "max-video-preview": -1}).tap do |meta|
      expect(meta).to have_tag("meta", with: {content: "noindex, max-snippet:-1, max-video-preview:-1", name: "robots"})
    end
  end
end
