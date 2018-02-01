require 'spec_helper'

describe MetaTags::ViewHelper, 'displaying keywords' do
  subject { ActionView::Base.new }

  it 'does not display keywords if blank' do
    subject.keywords('')
    expect(subject.display_meta_tags).to eq('')

    subject.keywords([])
    expect(subject.display_meta_tags).to eq('')
  end

  it 'displays keywords when "keywords" used' do
    subject.keywords('some-keywords')
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "some-keywords", name: "keywords" })
    end
  end

  it 'displays keywords when "set_meta_tags" used' do
    subject.set_meta_tags(keywords: 'some-keywords')
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "some-keywords", name: "keywords" })
    end
  end

  it 'displays default keywords' do
    subject.display_meta_tags(site: 'someSite', keywords: 'some-keywords').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "some-keywords", name: "keywords" })
    end
  end

  it 'uses custom keywords if given' do
    subject.keywords('some-keywords')
    subject.display_meta_tags(site: 'someSite', keywords: 'default_keywords').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "some-keywords", name: "keywords" })
    end
  end

  it 'joins keywords from Array' do
    subject.display_meta_tags(site: 'someSite', keywords: %w[keyword1 keyword2]).tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "keyword1, keyword2", name: "keywords" })
    end
  end

  it 'joins keywords from nested Arrays' do
    subject.display_meta_tags(site: 'someSite', keywords: [%w[keyword1 keyword2], 'keyword3']).tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "keyword1, keyword2, keyword3", name: "keywords" })
    end
  end

  context 'with the default configuration' do
    it 'lowercases keywords' do
      subject.display_meta_tags(site: 'someSite', keywords: 'someKeywords').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: 'somekeywords', name: 'keywords' })
      end
    end
  end

  context 'when `keywords_lowercase` is false' do
    it 'does not lowercase keywords' do
      MetaTags.config.keywords_lowercase = false
      subject.display_meta_tags(site: 'someSite', keywords: 'someKeywords').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: 'someKeywords', name: 'keywords' })
      end
    end
  end
end
