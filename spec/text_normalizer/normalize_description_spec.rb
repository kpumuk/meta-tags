require 'spec_helper'

describe MetaTags::TextNormalizer, '.normalize_description' do
  describe 'description limit setting' do
    let(:description) { 'd' * (MetaTags.config.description_limit + 10) }

    it 'truncates description when limit is reached' do
      expect(subject.normalize_description(description)).to eq('d' * MetaTags.config.description_limit)
    end

    it 'does not truncate description when limit is 0 or nil' do
      MetaTags.config.description_limit = 0
      expect(subject.normalize_description(description)).to eq(description)

      MetaTags.config.title_limit = nil
      expect(subject.normalize_description(description)).to eq(description)
    end
  end
end
