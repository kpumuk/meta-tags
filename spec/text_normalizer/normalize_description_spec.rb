# frozen_string_literal: true

require 'spec_helper'

describe MetaTags::TextNormalizer, '.normalize_description' do
  context 'description limit setting' do
    before do
      @description = 'd' * (MetaTags.config.description_limit + 10)
    end

    it 'should truncate description when limit is reached' do
      expect(subject.normalize_description(@description)).to eq('d' * MetaTags.config.description_limit)
    end

    it 'should not truncate description when limit is 0 or nil' do
      MetaTags.config.description_limit = 0
      expect(subject.normalize_description(@description)).to eq(@description)

      MetaTags.config.title_limit = nil
      expect(subject.normalize_description(@description)).to eq(@description)
    end
  end
end
