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
