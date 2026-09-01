# frozen_string_literal: true

require "spec_helper"

RSpec.describe MetaTags::ViewHelper do
  describe "displaying canonical url" do
    it "does not display canonical url by default" do
      subject.display_meta_tags(site: "someSite").tap do |meta|
        expect(meta).not_to have_tag("link", with: {href: "http://example.com/base/url", rel: "canonical"})
      end
    end

    it 'displays canonical url when "set_meta_tags" used' do
      subject.set_meta_tags(canonical: "http://example.com/base/url")
      subject.display_meta_tags(site: "someSite").tap do |meta|
        expect(meta).to have_tag("link", with: {href: "http://example.com/base/url", rel: "canonical"})
      end
    end

    it "displays default canonical url" do
      subject.display_meta_tags(site: "someSite", canonical: "http://example.com/base/url").tap do |meta|
        expect(meta).to have_tag("link", with: {href: "http://example.com/base/url", rel: "canonical"})
      end
    end

    it "does display canonical url when page is marked as noindex per default" do
      subject.set_meta_tags(canonical: "http://example.com/base/url", noindex: true)
      subject.display_meta_tags(site: "someSite").tap do |meta|
        expect(meta).to have_tag("link", with: {href: "http://example.com/base/url", rel: "canonical"})
      end
    end

    describe "with config.skip_canonical_links_on_noindex is set" do
      around do |example|
        default = MetaTags.config.skip_canonical_links_on_noindex
        MetaTags.config.skip_canonical_links_on_noindex = true
        example.run
        MetaTags.config.skip_canonical_links_on_noindex = default
      end

      it "does display canonical url when page is marked as index" do
        subject.set_meta_tags(canonical: "http://example.com/base/url", index: true)
        subject.display_meta_tags(site: "someSite").tap do |meta|
          expect(meta).to have_tag("link", with: {href: "http://example.com/base/url", rel: "canonical"})
        end
      end

      [
        ["nil", nil, []],
        ["false", false, []],
        ["an empty crawler list", [], []],
        ["true", true, ["robots"]],
        ["a scalar crawler", "googlebot", ["googlebot"]],
        ["a nonempty crawler list", ["googlebot", "bingbot"], ["googlebot", "bingbot"]]
      ].each do |description, noindex, robots_names|
        it "keeps canonical and robots output aligned for #{description}" do
          subject.set_meta_tags(canonical: "http://example.com/base/url", noindex: noindex)
          subject.display_meta_tags(site: "someSite").tap do |meta|
            if robots_names.empty?
              expect(meta).not_to have_tag("meta", with: {content: "noindex"})
              expect(meta).to have_tag("link", with: {href: "http://example.com/base/url", rel: "canonical"})
              next
            end

            expect(meta).to have_tag("meta", count: robots_names.size, with: {content: "noindex"})

            robots_names.each do |name|
              expect(meta).to have_tag("meta", with: {content: "noindex", name: name})
            end

            expect(meta).not_to have_tag("link", with: {href: "http://example.com/base/url", rel: "canonical"})
          end
        end
      end

      [
        ["the dedicated helper", {noindex: true}, '<meta name="robots" content="noindex">'],
        ["a dedicated nil crawler", {noindex: [nil]}, '<meta name="" content="noindex">'],
        ["a dedicated false crawler", {noindex: [false]}, '<meta name="false" content="noindex">'],
        ["a structured directive", {robots: {noindex: true}}, '<meta name="robots" content="noindex">'],
        ["a scalar directive", {robots: "noindex"}, '<meta name="robots" content="noindex">'],
        [
          "an array directive",
          {robots: ["nofollow", "noindex"]},
          %(<meta name="robots" content="nofollow">\n<meta name="robots" content="noindex">)
        ],
        [
          "a disabled structured directive",
          {robots: {noindex: false, follow: true}},
          %(<link rel="canonical" href="http://example.com/base/url">\n<meta name="robots" content="follow">)
        ],
        ["a mixed-case directive", {robots: "NoIndex"}, '<meta name="robots" content="NoIndex">'],
        ["a comma-separated directive", {robots: "follow, noindex"}, '<meta name="robots" content="follow, noindex">'],
        [
          "a bot-specific mixed-case array directive",
          {googlebot: ["follow, NOINDEX"]},
          '<meta name="googlebot" content="follow, NOINDEX">'
        ],
        [
          "a near-match directive",
          {robots: "noindexing"},
          %(<link rel="canonical" href="http://example.com/base/url">\n<meta name="robots" content="noindexing">)
        ]
      ].each do |description, robots, expected|
        it "keeps canonical and exact robots output aligned for #{description}" do
          expect(subject.display_meta_tags({canonical: "http://example.com/base/url"}.merge(robots))).to eq(expected)
        end
      end
    end
  end

  describe "displaying alternate url" do
    it "does not display alternate url by default" do
      subject.display_meta_tags(site: "someSite").tap do |meta|
        expect(meta).not_to have_tag("link", with: {href: "http://example.fr/base/url", hreflang: "fr", rel: "alternate"})
      end
    end

    it 'displays alternate url when "set_meta_tags" used' do
      subject.set_meta_tags(alternate: {"fr" => "http://example.fr/base/url"})
      subject.display_meta_tags(site: "someSite").tap do |meta|
        expect(meta).to have_tag("link", with: {href: "http://example.fr/base/url", hreflang: "fr", rel: "alternate"})
      end
    end

    it "displays default alternate url" do
      subject.display_meta_tags(site: "someSite", alternate: {"fr" => "http://example.fr/base/url"}).tap do |meta|
        expect(meta).to have_tag("link", with: {href: "http://example.fr/base/url", hreflang: "fr", rel: "alternate"})
      end
    end

    it "does not display alternate without content" do
      subject.display_meta_tags(site: "someSite", alternate: {"zh-Hant" => ""}).tap do |meta|
        expect(meta).not_to have_tag("link", with: {href: "", hreflang: "zh-Hant", rel: "alternate"})
      end
    end

    it "allows to specify an array of alternate links" do
      subject.display_meta_tags(
        site: "someSite",
        alternate: [
          {href: "http://example.fr/base/url", hreflang: "fr"},
          {href: "http://example.com/feed.rss", type: "application/rss+xml", title: "RSS"},
          {href: "http://m.example.com/page-1", media: "only screen and (max-width: 640px)"}
        ]
      ).tap do |meta|
        expect(meta).to have_tag("link", with: {href: "http://example.fr/base/url", hreflang: "fr", rel: "alternate"})
        expect(meta).to have_tag("link", with: {href: "http://example.com/feed.rss", type: "application/rss+xml", title: "RSS", rel: "alternate"})
        expect(meta).to have_tag("link", with: {href: "http://m.example.com/page-1", media: "only screen and (max-width: 640px)", rel: "alternate"})
      end
    end

    [
      ["nil", nil, false],
      ["an empty string", "", false],
      ["whitespace", " \t", false],
      ["a valid URL", "http://example.fr/base/url", true]
    ].each do |description, href, renders|
      it "renders hash and array representations identically with #{description}" do
        hash_meta = subject.display_meta_tags(site: "someSite", alternate: {"fr" => href})
        array_meta = subject.display_meta_tags(site: "someSite", alternate: [{href: href, hreflang: "fr"}])

        expect(array_meta).to eq(hash_meta)

        if renders
          expect(array_meta).to have_tag("link", with: {href: href, hreflang: "fr", rel: "alternate"})
        else
          expect(array_meta).not_to have_tag("link", with: {rel: "alternate"})
        end
      end
    end
  end

  describe "displaying prev url" do
    it "does not display prev url by default" do
      subject.display_meta_tags(site: "someSite").tap do |meta|
        expect(meta).not_to have_tag("link", with: {href: "http://example.com/base/url", rel: "prev"})
      end
    end

    it 'displays prev url when "set_meta_tags" used' do
      subject.set_meta_tags(prev: "http://example.com/base/url")
      subject.display_meta_tags(site: "someSite").tap do |meta|
        expect(meta).to have_tag("link", with: {href: "http://example.com/base/url", rel: "prev"})
      end
    end

    it "displays default prev url" do
      subject.display_meta_tags(site: "someSite", prev: "http://example.com/base/url").tap do |meta|
        expect(meta).to have_tag("link", with: {href: "http://example.com/base/url", rel: "prev"})
      end
    end
  end

  describe "displaying next url" do
    it "does not display next url by default" do
      subject.display_meta_tags(site: "someSite").tap do |meta|
        expect(meta).not_to have_tag("link", with: {href: "http://example.com/base/url", rel: "next"})
      end
    end

    it 'displays next url when "set_meta_tags" used' do
      subject.set_meta_tags(next: "http://example.com/base/url")
      subject.display_meta_tags(site: "someSite").tap do |meta|
        expect(meta).to have_tag("link", with: {href: "http://example.com/base/url", rel: "next"})
      end
    end

    it "displays default next url" do
      subject.display_meta_tags(site: "someSite", next: "http://example.com/base/url").tap do |meta|
        expect(meta).to have_tag("link", with: {href: "http://example.com/base/url", rel: "next"})
      end
    end
  end

  describe "displaying image_src url" do
    it "does not display image_src url by default" do
      subject.display_meta_tags(site: "someSite").tap do |meta|
        expect(meta).not_to have_tag("link", with: {href: "http://example.com/base/url", rel: "image_src"})
      end
    end

    it 'displays image_src url when "set_meta_tags" used' do
      subject.set_meta_tags(image_src: "http://example.com/base/url")
      subject.display_meta_tags(site: "someSite").tap do |meta|
        expect(meta).to have_tag("link", with: {href: "http://example.com/base/url", rel: "image_src"})
      end
    end

    it "displays default image_src url" do
      subject.display_meta_tags(site: "someSite", image_src: "http://example.com/base/url").tap do |meta|
        expect(meta).to have_tag("link", with: {href: "http://example.com/base/url", rel: "image_src"})
      end
    end
  end

  describe "displaying amphtml url" do
    it "does not display amphtml url by default" do
      subject.display_meta_tags(site: "someSite").tap do |meta|
        expect(meta).not_to have_tag("link", with: {href: "http://example.com/base/url.amp", rel: "amphtml"})
      end
    end

    it 'displays amphtml url when "set_meta_tags" used' do
      subject.set_meta_tags(amphtml: "http://example.com/base/url.amp")
      subject.display_meta_tags(site: "someSite").tap do |meta|
        expect(meta).to have_tag("link", with: {href: "http://example.com/base/url.amp", rel: "amphtml"})
      end
    end

    it "displays default amphtml url" do
      subject.display_meta_tags(site: "someSite", amphtml: "http://example.com/base/url.amp").tap do |meta|
        expect(meta).to have_tag("link", with: {href: "http://example.com/base/url.amp", rel: "amphtml"})
      end
    end
  end

  describe "displaying manifest url" do
    it "does not display manifest url by default" do
      subject.display_meta_tags(site: "someSite").tap do |meta|
        expect(meta).not_to have_tag("link", with: {rel: "manifest"})
      end
    end

    it 'displays manifest url when "set_meta_tags" used' do
      subject.set_meta_tags(manifest: "/manifest.webmanifest")
      subject.display_meta_tags(site: "someSite").tap do |meta|
        expect(meta).to have_tag("link", with: {href: "/manifest.webmanifest", rel: "manifest"})
      end
    end

    it "displays default manifest url" do
      subject.display_meta_tags(site: "someSite", manifest: "/manifest.webmanifest").tap do |meta|
        expect(meta).to have_tag("link", with: {href: "/manifest.webmanifest", rel: "manifest"})
      end
    end
  end
end
