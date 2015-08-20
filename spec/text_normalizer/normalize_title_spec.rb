require 'spec_helper'

describe MetaTags::TextNormalizer, '.normalize_title' do
  context 'when site_title is blank' do
    it 'should return title when site_title is blank' do
      expect(subject.normalize_title(nil, 'title', '-')).to eq('title')
      expect(subject.normalize_title('', 'title', '-')).to eq('title')
    end

    it 'should join title parts with separator' do
      expect(subject.normalize_title('', %w[title subtitle], '-')).to eq('title-subtitle')
    end

    it 'should reverse title parts when reverse is true' do
      expect(subject.normalize_title('', %w[title subtitle], '-', true)).to eq('subtitle-title')
    end
  end

  context 'when site_title is specified' do
    it 'should join title and site_title with separator' do
      expect(subject.normalize_title('site', 'title', '-')).to eq('site-title')
    end

    it 'should join title parts and site_title with separator' do
      expect(subject.normalize_title('site', %w[title subtitle], '-')).to eq('site-title-subtitle')
    end

    it 'should reverse title parts when reverse is true' do
      expect(subject.normalize_title('site', %w[title subtitle], '-', true)).to eq('subtitle-title-site')
    end

    it 'should not add title when site title is longer than limit' do
      site_title = 'a' * (MetaTags.config.title_limit - 2)
      expect(subject.normalize_title(site_title, 'title', '---')).to eq(site_title[0..-2])
    end

    it 'should truncate title when limit is reached' do
      site_title = 'a' * 20
      title = 'b' * (MetaTags.config.title_limit + 10)
      expect(subject.normalize_title(site_title, title, '-')).to eq("#{site_title}-#{'b' * (MetaTags.config.title_limit - 21)}")
    end
  end
end
