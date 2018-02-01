require 'spec_helper'

describe MetaTags::TextNormalizer, '.normalize_title' do
  context 'when site_title is blank' do
    it 'returns title when site_title is blank' do
      expect(subject.normalize_title(nil, 'title', '-')).to eq('title')
      expect(subject.normalize_title('', 'title', '-')).to eq('title')
    end

    it 'joins title parts with separator' do
      expect(subject.normalize_title('', %w[title subtitle], '-')).to eq('title-subtitle')
    end

    it 'reverses title parts when reverse is true' do
      expect(subject.normalize_title('', %w[title subtitle], '-', true)).to eq('subtitle-title')
    end

    it 'does not truncate title when limit is equal to the title length' do
      title = 'b' * MetaTags.config.title_limit
      expect(subject.normalize_title('', title, '-')).to eq(title)
    end

    it 'truncates title when limit is reached' do
      title = 'b' * (MetaTags.config.title_limit + 20)
      expect(subject.normalize_title('', title, '-')).to eq('b' * MetaTags.config.title_limit)
    end

    it 'truncates last part of the title when reverse is true' do
      title = [
        'a' * (MetaTags.config.title_limit - 20),
        'b' * 40,
      ]
      expect(subject.normalize_title('', title, '-', true)).to eq("#{'b' * 40}-#{'a' * (MetaTags.config.title_limit - 41)}")
    end
  end

  context 'when site_title is specified' do
    it 'returns site when title is blank' do
      expect(subject.normalize_title('site', nil, '-')).to eq('site')
      expect(subject.normalize_title('site', '', '-')).to eq('site')
    end

    it 'joins title and site_title with separator' do
      expect(subject.normalize_title('site', 'title', '-')).to eq('site-title')
    end

    it 'joins title parts and site_title with separator' do
      expect(subject.normalize_title('site', %w[title subtitle], '-')).to eq('site-title-subtitle')
    end

    it 'reverses title parts when reverse is true' do
      expect(subject.normalize_title('site', %w[title subtitle], '-', true)).to eq('subtitle-title-site')
    end

    it 'does not add title when site title is longer than limit' do
      l = MetaTags.config.title_limit
      site_title = 'a' * (l + 1)
      expect(subject.normalize_title(site_title, 'title', '---')).to eq(site_title[0, l])
      expect(subject.normalize_title(site_title[0, l - 0], 'title', '---')).to eq(site_title[0, l - 0])
      expect(subject.normalize_title(site_title[0, l - 1], 'title', '---')).to eq(site_title[0, l - 1])
      expect(subject.normalize_title(site_title[0, l - 2], 'title', '---')).to eq(site_title[0, l - 2])
      expect(subject.normalize_title(site_title[0, l - 3], 'title', '---')).to eq(site_title[0, l - 3])
      expect(subject.normalize_title(site_title[0, l - 4], 'title', '---')).to eq("#{site_title[0, l - 4]}---t")
    end

    it 'truncates title when limit is reached' do
      site_title = 'a' * 20
      title = 'b' * (MetaTags.config.title_limit + 10)
      expect(subject.normalize_title(site_title, title, '-')).to eq("#{site_title}-#{'b' * (MetaTags.config.title_limit - 21)}")
    end

    it 'does not truncate title when title_limit is 0 or nil' do
      site_title = 'a' * 20
      title = 'b' * (MetaTags.config.title_limit + 10)

      MetaTags.config.title_limit = 0
      expect(subject.normalize_title(site_title, title, '-')).to eq("#{site_title}-#{title}")

      MetaTags.config.title_limit = nil
      expect(subject.normalize_title(site_title, title, '-')).to eq("#{site_title}-#{title}")
    end
  end

  context 'when truncate_site_title_first is true' do
    before do
      MetaTags.config.truncate_site_title_first = true
    end

    it 'does not add site title when title is longer than limit' do
      l = MetaTags.config.title_limit
      title = 'a' * (l + 1)
      expect(subject.normalize_title('site', title, '---')).to eq(title[0, l])
      expect(subject.normalize_title('site', title[0, l - 0], '---')).to eq(title[0, l - 0])
      expect(subject.normalize_title('site', title[0, l - 1], '---')).to eq(title[0, l - 1])
      expect(subject.normalize_title('site', title[0, l - 2], '---')).to eq(title[0, l - 2])
      expect(subject.normalize_title('site', title[0, l - 3], '---')).to eq(title[0, l - 3])
      expect(subject.normalize_title('site', title[0, l - 4], '---')).to eq("s---#{title[0, l - 4]}")
    end

    it 'truncates site title when limit is reached' do
      site_title = 'a' * (MetaTags.config.title_limit + 10)
      title = 'b' * 20
      expect(subject.normalize_title(site_title, title, '-')).to eq("#{'a' * (MetaTags.config.title_limit - 21)}-#{title}")
    end

    it 'does not truncate site title when title_limit is 0 or nil' do
      site_title = 'a' * (MetaTags.config.title_limit + 10)
      title = 'b' * 20

      MetaTags.config.title_limit = 0
      expect(subject.normalize_title(site_title, title, '-')).to eq("#{site_title}-#{title}")

      MetaTags.config.title_limit = nil
      expect(subject.normalize_title(site_title, title, '-')).to eq("#{site_title}-#{title}")
    end
  end
end
