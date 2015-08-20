require 'spec_helper'

describe MetaTags::ViewHelper do
  subject { ActionView::Base.new }

  context 'displaying canonical url' do
    it 'should not display canonical url by default' do
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to_not have_tag('link', with: { href: "http://example.com/base/url", rel: "canonical" })
      end
    end

    it 'should display canonical url when "set_meta_tags" used' do
      subject.set_meta_tags(canonical: 'http://example.com/base/url')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.com/base/url", rel: "canonical" })
      end
    end

    it 'should display default canonical url' do
      subject.display_meta_tags(site: 'someSite', canonical: 'http://example.com/base/url').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.com/base/url", rel: "canonical" })
      end
    end
  end

  context 'displaying alternate url' do
    it 'should not display alternate url by default' do
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to_not have_tag('link', with: { href: "http://example.fr/base/url", hreflang: "fr", rel: "alternate" })
      end
    end

    it 'should display alternate url when "set_meta_tags" used' do
      subject.set_meta_tags(alternate: { 'fr' => 'http://example.fr/base/url' })
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.fr/base/url", hreflang: "fr", rel: "alternate" })
      end
    end

    it 'should display default alternate url' do
      subject.display_meta_tags(site: 'someSite', alternate: { 'fr' => 'http://example.fr/base/url' }).tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.fr/base/url", hreflang: "fr", rel: "alternate" })
      end
    end

    it "should not display alternate without content" do
      subject.display_meta_tags(site: 'someSite', alternate: {'zh-Hant' => ''}).tap do |meta|
        expect(meta).to_not have_tag('link', with: { href: "", hreflang: "zh-Hant", rel: "alternate" })
      end
    end

    it 'should allow to specify an array of alternate links' do
      subject.display_meta_tags(site: 'someSite', alternate: [
        { href: 'http://example.fr/base/url', hreflang: 'fr' },
        { href: 'http://example.com/feed.rss', type: 'application/rss+xml', title: 'RSS' },
        { href: 'http://m.example.com/page-1', media: 'only screen and (max-width: 640px)'},
      ]).tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.fr/base/url", hreflang: "fr", rel: "alternate" })
        expect(meta).to have_tag('link', with: { href: "http://example.com/feed.rss", type: "application/rss+xml", title: 'RSS', rel: "alternate" })
        expect(meta).to have_tag('link', with: { href: "http://m.example.com/page-1", media: 'only screen and (max-width: 640px)', rel: "alternate" })
      end
    end
  end

  context 'displaying author link' do
    it 'should display author link when "set_meta_tags" used' do
      subject.set_meta_tags(author: 'http://plus.google.com/profile/url')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://plus.google.com/profile/url", rel: "author" })
      end
    end
  end

  context 'displaying publisher link' do
    it 'should display publisher link when "set_meta_tags" used' do
      subject.set_meta_tags(publisher: 'http://plus.google.com/myprofile_url')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://plus.google.com/myprofile_url", rel: "publisher" })
      end
    end
  end

  context 'displaying prev url' do
    it 'should not display prev url by default' do
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to_not have_tag('link', with: { href: "http://example.com/base/url", rel: "prev" })
      end
    end

    it 'should display prev url when "set_meta_tags" used' do
      subject.set_meta_tags(prev: 'http://example.com/base/url')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.com/base/url", rel: "prev" })
      end
    end

    it 'should display default prev url' do
      subject.display_meta_tags(site: 'someSite', prev: 'http://example.com/base/url').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.com/base/url", rel: "prev" })
      end
    end
  end

  context 'displaying next url' do
    it 'should not display next url by default' do
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to_not have_tag('link', with: { href: "http://example.com/base/url", rel: "next" })
      end
    end

    it 'should display next url when "set_meta_tags" used' do
      subject.set_meta_tags(next: 'http://example.com/base/url')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.com/base/url", rel: "next" })
      end
    end

    it 'should display default next url' do
      subject.display_meta_tags(site: 'someSite', next: 'http://example.com/base/url').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.com/base/url", rel: "next" })
      end
    end
  end
end
