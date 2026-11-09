# frozen_string_literal: true

require "spec_helper"

RSpec.describe MetaTags::ViewHelper, "displaying keywords" do
  it "does not display keywords if blank" do
    subject.keywords("")
    expect(subject.display_meta_tags).to eq("")

    subject.keywords([])
    expect(subject.display_meta_tags).to eq("")
  end

  it 'displays keywords when "keywords" used' do
    subject.keywords("some-keywords")
    subject.display_meta_tags(site: "someSite").tap do |meta|
      expect(meta).to have_tag("meta", with: {content: "some-keywords", name: "keywords"})
    end
  end

  it 'displays keywords when "set_meta_tags" used' do
    subject.set_meta_tags(keywords: "some-keywords")
    subject.display_meta_tags(site: "someSite").tap do |meta|
      expect(meta).to have_tag("meta", with: {content: "some-keywords", name: "keywords"})
    end
  end

  it "displays default keywords" do
    subject.display_meta_tags(site: "someSite", keywords: "some-keywords").tap do |meta|
      expect(meta).to have_tag("meta", with: {content: "some-keywords", name: "keywords"})
    end
  end

  it "uses custom keywords if given" do
    subject.keywords("some-keywords")
    subject.display_meta_tags(site: "someSite", keywords: "default_keywords").tap do |meta|
      expect(meta).to have_tag("meta", with: {content: "some-keywords", name: "keywords"})
    end
  end

  it "joins keywords from Array" do
    subject.display_meta_tags(site: "someSite", keywords: %w[keyword1 keyword2]).tap do |meta|
      expect(meta).to have_tag("meta", with: {content: "keyword1, keyword2", name: "keywords"})
    end
  end

  it "joins keywords from nested Arrays" do
    subject.display_meta_tags(site: "someSite", keywords: [%w[keyword1 keyword2], "keyword3"]).tap do |meta|
      expect(meta).to have_tag("meta", with: {content: "keyword1, keyword2, keyword3", name: "keywords"})
    end
  end

  context "with the default configuration" do
    it "lowercases keywords" do
      subject.display_meta_tags(site: "someSite", keywords: "someKeywords").tap do |meta|
        expect(meta).to have_tag("meta", with: {content: "somekeywords", name: "keywords"})
      end
    end
  end

  context "when `keywords_lowercase` is false" do
    it "does not lowercase keywords" do
      MetaTags.config.keywords_lowercase = false
      MetaTags.config.keywords_limit = 27
      subject.display_meta_tags(site: "someSite", keywords: ["someKeywords", "OtherKeywords", Array.new(32, "TAIL")]).tap do |meta|
        expect(meta).to have_tag("meta", with: {content: "someKeywords, OtherKeywords", name: "keywords"})
      end
    end
  end

  it "truncates keywords when limit is a positive integer" do
    MetaTags.config.keywords_limit = 10

    subject.display_meta_tags(keywords: "k" * 300).tap do |meta|
      expect(meta).to have_tag("meta", with: {content: "k" * 10, name: "keywords"})
    end
  end

  it "lowercases and truncates plain HTML-safe keywords without trusting or changing them" do
    MetaTags.config.keywords_limit = 12
    MetaTags.config.keywords_separator = " > ".html_safe.freeze
    keywords = [" ALPHA ".html_safe.freeze, '"BETA"'.html_safe.freeze].freeze

    meta = subject.display_meta_tags(keywords: keywords)

    expect(meta).to include('content="alpha &gt; &quot;bet"')
    expect(keywords).to eq([" ALPHA ", '"BETA"'])
    expect(MetaTags.config.keywords_separator).to eq(" > ")
  end

  it "counts cleaned, lowercased characters and escaped separators in nested frozen arrays" do
    MetaTags.config.keywords_limit = 10
    MetaTags.config.keywords_separator = " <b>&gt;</b> "
    keyword = double(to_str: " &#304; ")
    keywords = [nil, "<i></i>", [keyword, " CAFÉ "].freeze, Array.new(32, "TAIL").freeze].freeze

    meta = subject.display_meta_tags(keywords: keywords)

    expect(meta).to eq('<meta name="keywords" content="i̇ &gt; café">')
    expect(meta.encoding).to eq(Encoding::UTF_8)
    expect(meta).to be_html_safe
    expect(keywords).to eq([nil, "<i></i>", [keyword, " CAFÉ "], Array.new(32, "TAIL")])
    expect(MetaTags.config.keywords_separator).to eq(" <b>&gt;</b> ")
  end

  {" " => "ab, cd", nil => "ab, cd e"}.each do |natural_separator, expected|
    it "truncates the overflowing cleaned item with natural separator #{natural_separator.inspect}" do
      MetaTags.config.keywords_limit = 8
      MetaTags.config.truncate_on_natural_separator = natural_separator

      meta = subject.display_meta_tags(keywords: ["<b>AB</b>", " CD   EFG ", Array.new(32, "tail")])

      expect(meta).to eq(%(<meta name="keywords" content="#{expected}">))
    end
  end

  it "fits a complete item exactly without including a trailing separator" do
    MetaTags.config.keywords_limit = 7

    meta = subject.display_meta_tags(keywords: ["<b>AB</b>", nil, "<i></i>", "CDE", Array.new(32, "tail")])

    expect(meta).to eq('<meta name="keywords" content="ab, cde">')
  end

  it "ignores discarded non-String-like items but still rejects consumed ones" do
    skip("Fails RBS") if ENV["RBS_TEST_TARGET"]
    MetaTags.config.keywords_limit = 2

    meta = subject.display_meta_tags(keywords: ["<b>AB</b>", Array.new(32, "tail"), 5])

    expect(meta).to eq('<meta name="keywords" content="ab">')
    expect {
      subject.display_meta_tags(keywords: [5, Array.new(32, "tail"), "<b>AB</b>"])
    }.to raise_error(ArgumentError, "Expected a string or an object that implements #to_str")
  end

  it "ignores discarded malformed strings but still rejects consumed ones" do
    MetaTags.config.keywords_limit = 2
    malformed = "\xFF".b.force_encoding(Encoding::UTF_8)

    meta = subject.display_meta_tags(keywords: ["<b>AB</b>", Array.new(32, "tail"), malformed])

    expect(meta).to eq('<meta name="keywords" content="ab">')
    expect {
      subject.display_meta_tags(keywords: [malformed, Array.new(32, "tail"), "<b>AB</b>"])
    }.to raise_error(ArgumentError, "invalid byte sequence in UTF-8")
  end

  it "does not coerce discarded String-like keywords" do
    MetaTags.config.keywords_limit = 2
    [Object.new, +"CD"].each do |keyword|
      def keyword.to_str
        raise "Discarded keyword must not be coerced"
      end

      meta = subject.display_meta_tags(keywords: ["AB", Array.new(32, nil), keyword])

      expect(meta).to eq('<meta name="keywords" content="ab">')
    end
  end

  it "does not truncate keywords when limit is 0" do
    MetaTags.config.keywords_limit = 0

    subject.display_meta_tags(keywords: ["<b>AB</b>", ["K" * 300]]).tap do |meta|
      expect(meta).to have_tag("meta", with: {content: "ab, " + "k" * 300, name: "keywords"})
    end
  end

  it "does not truncate keywords when limit is nil" do
    MetaTags.config.keywords_limit = nil

    subject.display_meta_tags(keywords: ["<b>AB</b>", ["K" * 300]]).tap do |meta|
      expect(meta).to have_tag("meta", with: {content: "ab, " + "k" * 300, name: "keywords"})
    end
  end

  context "when `truncate_array_items_at_boundaries` is true" do
    it "keeps only whole keyword items that fit" do
      MetaTags.config.keywords_limit = 5
      MetaTags.config.truncate_array_items_at_boundaries = true

      subject.display_meta_tags(site: "someSite", keywords: %w[a a aaaa aa]).tap do |meta|
        expect(meta).to have_tag("meta", with: {content: "a, a", name: "keywords"})
      end
    end

    it "still truncates an oversized first item with blank or nonblank suffixes" do
      MetaTags.config.keywords_limit = 4
      MetaTags.config.truncate_array_items_at_boundaries = true

      ["<i></i>", "TAIL"].each do |suffix|
        meta = subject.display_meta_tags(keywords: [nil, "<b>ABCDEF</b>", Array.new(32, suffix)])

        expect(meta).to eq('<meta name="keywords" content="abcd">')
      end
    end
  end
end
