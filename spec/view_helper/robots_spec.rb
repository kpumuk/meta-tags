# frozen_string_literal: true

require "spec_helper"

RSpec.describe MetaTags::ViewHelper, "displaying robots meta tags" do
  [:robots, :googlebot, :bingbot].each do |bot|
    it "preserves scalar custom values for :#{bot}" do
      expect(subject.display_meta_tags(bot => "noindex, nofollow, nojokes"))
        .to eq(%(<meta name="#{bot}" content="noindex, nofollow, nojokes">))
    end

    it "preserves array custom values for :#{bot}" do
      expect(subject.display_meta_tags(bot => ["noindex", "nofollow"]))
        .to eq(<<~HTML.chomp)
          <meta name="#{bot}" content="noindex">
          <meta name="#{bot}" content="nofollow">
        HTML
    end
  end

  it "renders valued and valueless directives while omitting disabled directives" do
    expect(
      subject.display_meta_tags(
        robots: {indexifembedded: nil, "max-snippet": -1, nosnippet: false},
        googlebot: {nosnippet: true, unavailable_after: "2026-12-31", noimageindex: false},
        bingbot: {noimageindex: nil, "max-image-preview": "large", nosnippet: false}
      )
    ).to eq(<<~HTML.chomp)
      <meta name="robots" content="indexifembedded, max-snippet:-1">
      <meta name="googlebot" content="nosnippet, unavailable_after:2026-12-31">
      <meta name="bingbot" content="noimageindex, max-image-preview:large">
    HTML
  end

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
    expect(subject.display_meta_tags(robots: {"max-snippet": -1, "max-video-preview": -1}))
      .to eq('<meta name="robots" content="noindex, max-snippet:-1, max-video-preview:-1">')
  end

  it "merges bot-specific directives with helper-based robots directives" do
    subject.set_meta_tags(noindex: "googlebot", googlebot: {unavailable_after: "2026-12-31"})
    expect(subject.display_meta_tags)
      .to eq('<meta name="googlebot" content="noindex, unavailable_after:2026-12-31">')
  end
end
