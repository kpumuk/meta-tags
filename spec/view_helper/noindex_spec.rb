# frozen_string_literal: true

require 'spec_helper'

describe MetaTags::ViewHelper do
  subject { ActionView::Base.new }

  describe 'displaying noindex' do
    it 'displays noindex when "noindex" used' do
      subject.noindex(true)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "noindex", name: "robots" })
      end
    end

    it 'displays noindex when "set_meta_tags" used' do
      subject.set_meta_tags(noindex: true)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "noindex", name: "robots" })
      end
    end

    it 'uses custom noindex if given' do
      subject.noindex('some-noindex')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "noindex", name: "some-noindex" })
      end
    end

    it 'displays nothing by default' do
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).not_to have_tag('meta', with: { content: "noindex" })
      end
    end

    it "displays nothing if given false" do
      subject.set_meta_tags(noindex: false)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).not_to have_tag('meta', with: { content: "robots" })
      end
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).not_to have_tag('meta', with: { content: "noindex" })
      end
    end
  end

  describe 'displaying nofollow' do
    it 'displays nofollow when "nofollow" used' do
      subject.nofollow(true)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "nofollow", name: "robots" })
      end
    end

    it 'displays nofollow when "set_meta_tags" used' do
      subject.set_meta_tags(nofollow: true)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "nofollow", name: "robots" })
      end
    end

    it 'uses custom nofollow if given' do
      subject.nofollow('some-nofollow')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "nofollow", name: "some-nofollow" })
      end
    end

    it 'displays nothing by default' do
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).not_to have_tag('meta', with: { content: "nofollow" })
      end
    end
  end

  describe 'displaying both nofollow and noindex' do
    it 'is displayed when set using helpers' do
      subject.noindex(true)
      subject.nofollow(true)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "noindex, nofollow", name: "robots" })
      end
    end

    it 'is displayed when "set_meta_tags" used' do
      subject.set_meta_tags(nofollow: true, noindex: true)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "noindex, nofollow", name: "robots" })
      end
    end

    it 'uses custom name if string is used' do
      subject.noindex('some-name')
      subject.nofollow('some-name')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "noindex, nofollow", name: "some-name" })
      end
    end

    it 'displays two meta tags when different names used' do
      subject.noindex('some-noindex')
      subject.nofollow('some-nofollow')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "noindex", name: "some-noindex" })
        expect(meta).to have_tag('meta', with: { content: "nofollow", name: "some-nofollow" })
      end
    end
  end

  context 'when displaying both follow and index' do
    it 'renders when "set_meta_tags" used' do
      subject.set_meta_tags(follow: true, index: true)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "index, follow", name: "robots" })
      end
    end

    it 'uses custom name if string is used' do
      subject.set_meta_tags(follow: 'some-name123', index: 'some-name123')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "index, follow", name: "some-name123" })
      end
    end

    it 'renders two meta tags when different names used' do
      subject.set_meta_tags(follow: 'some-follow', index: 'some-index')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "index", name: "some-index" })
        expect(meta).to have_tag('meta', with: { content: "follow", name: "some-follow" })
      end
    end
  end

  context 'when displaying both follow and noindex when nofollow and index set by mistake' do
    it 'renders when "set_meta_tags" used' do
      subject.set_meta_tags(follow: true, index: true, nofollow: true, noindex: true)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "noindex, follow", name: "robots" })
      end
    end

    it 'uses custom name if string is used' do
      subject.set_meta_tags(follow: 'some-name', index: 'some-name', nofollow: 'some-name', noindex: 'some-name')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "noindex, follow", name: "some-name" })
      end
    end

    it 'renders two meta tags when different names used' do
      subject.set_meta_tags(follow: 'some-follow', index: 'some-index', nofollow: 'some-nofollow', noindex: 'some-noindex')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "index", name: "some-index" })
        expect(meta).to have_tag('meta', with: { content: "follow", name: "some-follow" })
        expect(meta).to have_tag('meta', with: { content: "noindex", name: "some-noindex" })
        expect(meta).to have_tag('meta', with: { content: "nofollow", name: "some-nofollow" })
      end
    end
  end

  context 'when displaying noarchive' do
    it 'renders noarchive when "set_meta_tags" used' do
      subject.set_meta_tags(noarchive: true)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "noarchive", name: "robots" })
      end
    end

    it 'renders nothing if given false' do
      subject.set_meta_tags(noarchive: false)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).not_to have_tag('meta', with: { content: "noarchive", name: "robots" })
      end
    end

    it 'uses custom noarchive if given' do
      subject.set_meta_tags(noarchive: 'some-robots')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "noarchive", name: "some-robots" })
      end
    end
  end
end
