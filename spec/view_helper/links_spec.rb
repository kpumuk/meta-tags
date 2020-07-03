# frozen_string_literal: true

require 'spec_helper'

describe MetaTags::ViewHelper do
  describe 'displaying canonical url' do
    it 'does not display canonical url by default' do
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).not_to have_tag('link', with: { href: "http://example.com/base/url", rel: "canonical" })
      end
    end

    it 'displays canonical url when "set_meta_tags" used' do
      subject.set_meta_tags(canonical: 'http://example.com/base/url')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.com/base/url", rel: "canonical" })
      end
    end

    it 'displays default canonical url' do
      subject.display_meta_tags(site: 'someSite', canonical: 'http://example.com/base/url').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.com/base/url", rel: "canonical" })
      end
    end

    it 'does display canonical url when page is marked as noindex per default' do
      subject.set_meta_tags(canonical: 'http://example.com/base/url', noindex: true)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.com/base/url", rel: "canonical" })
      end
    end

    describe 'with config.skip_canonical_links_on_noindex is set' do
      around do |example|
        default = MetaTags.config.skip_canonical_links_on_noindex
        MetaTags.config.skip_canonical_links_on_noindex = true
        example.run
        MetaTags.config.skip_canonical_links_on_noindex = default
      end

      it 'does display canonical url when page is marked as index' do
        subject.set_meta_tags(canonical: 'http://example.com/base/url', index: true)
        subject.display_meta_tags(site: 'someSite').tap do |meta|
          expect(meta).to have_tag('link', with: { href: "http://example.com/base/url", rel: "canonical" })
        end
      end

      it 'does not display canonical url when page is marked as noindex' do
        subject.set_meta_tags(canonical: 'http://example.com/base/url', noindex: true)
        subject.display_meta_tags(site: 'someSite').tap do |meta|
          expect(meta).not_to have_tag('link', with: { href: "http://example.com/base/url", rel: "canonical" })
          expect(meta).not_to have_tag('meta', with: { content: "http://example.com/base/url", name: "canonical" })
        end
      end
    end
  end

  describe 'displaying alternate url' do
    it 'does not display alternate url by default' do
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).not_to have_tag('link', with: { href: "http://example.fr/base/url", hreflang: "fr", rel: "alternate" })
      end
    end

    it 'displays alternate url when "set_meta_tags" used' do
      subject.set_meta_tags(alternate: { 'fr' => 'http://example.fr/base/url' })
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.fr/base/url", hreflang: "fr", rel: "alternate" })
      end
    end

    it 'displays default alternate url' do
      subject.display_meta_tags(site: 'someSite', alternate: { 'fr' => 'http://example.fr/base/url' }).tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.fr/base/url", hreflang: "fr", rel: "alternate" })
      end
    end

    it "does not display alternate without content" do
      subject.display_meta_tags(site: 'someSite', alternate: { 'zh-Hant' => '' }).tap do |meta|
        expect(meta).not_to have_tag('link', with: { href: "", hreflang: "zh-Hant", rel: "alternate" })
      end
    end

    it 'allows to specify an array of alternate links' do
      subject.display_meta_tags(
        site:      'someSite',
        alternate: [
          { href: 'http://example.fr/base/url', hreflang: 'fr' },
          { href: 'http://example.com/feed.rss', type: 'application/rss+xml', title: 'RSS' },
          { href: 'http://m.example.com/page-1', media: 'only screen and (max-width: 640px)' },
        ],
      ).tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.fr/base/url", hreflang: "fr", rel: "alternate" })
        expect(meta).to have_tag('link', with: { href: "http://example.com/feed.rss", type: "application/rss+xml", title: 'RSS', rel: "alternate" })
        expect(meta).to have_tag('link', with: { href: "http://m.example.com/page-1", media: 'only screen and (max-width: 640px)', rel: "alternate" })
      end
    end
  end

  describe 'displaying prev url' do
    it 'does not display prev url by default' do
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).not_to have_tag('link', with: { href: "http://example.com/base/url", rel: "prev" })
      end
    end

    it 'displays prev url when "set_meta_tags" used' do
      subject.set_meta_tags(prev: 'http://example.com/base/url')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.com/base/url", rel: "prev" })
      end
    end

    it 'displays default prev url' do
      subject.display_meta_tags(site: 'someSite', prev: 'http://example.com/base/url').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.com/base/url", rel: "prev" })
      end
    end
  end

  describe 'displaying next url' do
    it 'does not display next url by default' do
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).not_to have_tag('link', with: { href: "http://example.com/base/url", rel: "next" })
      end
    end

    it 'displays next url when "set_meta_tags" used' do
      subject.set_meta_tags(next: 'http://example.com/base/url')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.com/base/url", rel: "next" })
      end
    end

    it 'displays default next url' do
      subject.display_meta_tags(site: 'someSite', next: 'http://example.com/base/url').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.com/base/url", rel: "next" })
      end
    end
  end

  describe 'displaying image_src url' do
    it 'does not display image_src url by default' do
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).not_to have_tag('link', with: { href: "http://example.com/base/url", rel: "image_src" })
      end
    end

    it 'displays image_src url when "set_meta_tags" used' do
      subject.set_meta_tags(image_src: 'http://example.com/base/url')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.com/base/url", rel: "image_src" })
      end
    end

    it 'displays default image_src url' do
      subject.display_meta_tags(site: 'someSite', image_src: 'http://example.com/base/url').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.com/base/url", rel: "image_src" })
      end
    end
  end

  describe 'displaying amphtml url' do
    it 'does not display amphtml url by default' do
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).not_to have_tag('link', with: { href: "http://example.com/base/url.amp", rel: "amphtml" })
      end
    end

    it 'displays amphtml url when "set_meta_tags" used' do
      subject.set_meta_tags(amphtml: 'http://example.com/base/url.amp')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.com/base/url.amp", rel: "amphtml" })
      end
    end

    it 'displays default amphtml url' do
      subject.display_meta_tags(site: 'someSite', amphtml: 'http://example.com/base/url.amp').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "http://example.com/base/url.amp", rel: "amphtml" })
      end
    end
  end

  describe 'displaying manifest url' do
    it 'does not display manifest url by default' do
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).not_to have_tag('link', with: { rel: "manifest" })
      end
    end

    it 'displays manifest url when "set_meta_tags" used' do
      subject.set_meta_tags(manifest: '/manifest.webmanifest')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "/manifest.webmanifest", rel: "manifest" })
      end
    end

    it 'displays default manifest url' do
      subject.display_meta_tags(site: 'someSite', manifest: '/manifest.webmanifest').tap do |meta|
        expect(meta).to have_tag('link', with: { href: "/manifest.webmanifest", rel: "manifest" })
      end
    end
  end
end
