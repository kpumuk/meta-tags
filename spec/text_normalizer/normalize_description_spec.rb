# frozen_string_literal: true

require "spec_helper"

RSpec.describe MetaTags::TextNormalizer, ".normalize_description" do
  let(:description) { "d" * 20 }

  it "truncates description when limit is a positive integer" do
    MetaTags.config.description_limit = 10

    expect(subject.normalize_description(description)).to eq("d" * 10)
  end

  it "does not truncate description when limit is 0" do
    MetaTags.config.description_limit = 0

    expect(subject.normalize_description(description)).to eq(description)
  end

  it "does not truncate description when limit is nil" do
    MetaTags.config.description_limit = nil

    expect(subject.normalize_description(description)).to eq(description)
  end

  context "with unlimited descriptions" do
    before do
      MetaTags.config.description_limit = nil
    end

    {
      "" => "",
      " \t Some  Text\n " => "Some Text",
      "<b>Bold</b><!-- comment --> Text" => "Bold Text",
      "A &amp; &#66; &Aacute;" => "A & B Á",
      "\"Quote\" > A" => "\"Quote\" > A",
      "a\r\nb\rc" => "a b c",
      "a\0b" => "a b",
      "a\x01b\x0Bc" => "abc",
      "café 日本語" => "café 日本語"
    }.each do |input, expected|
      it "normalizes #{input.inspect} without marking it HTML-safe" do
        result = subject.normalize_description(input)

        expect(result).to eq(expected)
        expect(result.encoding).to eq(Encoding::UTF_8)
        expect(result).not_to be_html_safe
      end
    end

    it "returns independent untrusted strings for mutable, frozen, HTML-safe and String-like inputs" do
      original = " \t Some  Text\n "
      inputs = [+original, original.freeze, original.html_safe, original.html_safe.freeze, double(to_str: original)]

      inputs.each do |input|
        result = subject.normalize_description(input)

        expect(result).to eq("Some Text")
        expect(result).not_to be_html_safe
        result << " changed"
        expect(input.to_str).to eq(" \t Some  Text\n ")
      end
    end

    it "preserves US-ASCII encoding when cleaning up an empty string" do
      input = "".encode(Encoding::UTF_8)
      result = subject.cleanup_string(input)

      expect(result).to eq("")
      expect(result.encoding).to eq(Encoding::US_ASCII)
      expect(result).not_to be_html_safe
      result << "changed"
      expect(input).to eq("")
      expect(input.encoding).to eq(Encoding::UTF_8)
    end

    %w[US-ASCII ASCII-8BIT ISO-8859-1 Shift_JIS].each do |encoding|
      it "converts plain #{encoding} text to UTF-8 without changing the input" do
        input = "Plain text".encode(encoding)
        result = subject.normalize_description(input)

        expect(result).to eq("Plain text")
        expect(result.encoding).to eq(Encoding::UTF_8)
        expect(result).not_to be_html_safe
        expect(input.encoding).to eq(Encoding.find(encoding))
      end
    end

    it "preserves rejection of UTF-16LE input" do
      expect {
        subject.normalize_description("Plain text".encode("UTF-16LE"))
      }.to raise_error(Encoding::CompatibilityError)
    end

    it "keeps the Rails helper fallback when Loofah is unavailable" do
      expected = subject.helpers.strip_tags("")
      hide_const("Loofah")

      result = subject.strip_tags("")

      expect(result).to eq(expected)
      expect(result.encoding).to eq(expected.encoding)
      expect(result.html_safe?).to eq(expected.html_safe?)
    end
  end

  context "with text in Japanese" do
    let(:description) do
      "Microsoft Copilotは、あなたの言葉をパワフルなコンテンツに変える AI アシスタントです。あなたのニーズに合わせて、文章を生成、要約、編集、変換したり、コードや詩などの創造的なコンテンツを作成したりします。"
    end

    before do
      MetaTags.config.description_limit = 50
    end

    context "when natural separator has default value" do
      it "truncates description on space character" do
        expect(subject.normalize_description(description))
          .to eq("Microsoft Copilotは、あなたの言葉をパワフルなコンテンツに変える AI")
      end
    end

    context "when natural separator is set to nil" do
      before do
        MetaTags.config.truncate_on_natural_separator = nil
      end

      it "truncates description on unicode codepoint" do
        expect(subject.normalize_description(description)).to eq(description[0, 50])
      end
    end
  end
end
