require 'spec_helper'

describe MetaTags::ViewHelper do
  subject { ActionView::Base.new }

  context 'displaying noindex' do
    it 'should display noindex when "noindex" used' do
      subject.noindex(true)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "noindex", name: "robots" })
      end
    end

    it 'should display noindex when "set_meta_tags" used' do
      subject.set_meta_tags(noindex: true)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "noindex", name: "robots" })
      end
    end

    it 'should use custom noindex if given' do
      subject.noindex('some-noindex')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "noindex", name: "some-noindex" })
      end
    end

    it 'should display nothing by default' do
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to_not have_tag('meta', with: { content: "noindex" })
      end
    end

    it "should display nothing if given false" do
      subject.set_meta_tags(noindex: false)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to_not have_tag('meta', with: { content: "robots" })
      end
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to_not have_tag('meta', with: { content: "noindex" })
      end
    end
  end

  context 'displaying nofollow' do
    it 'should display nofollow when "nofollow" used' do
      subject.nofollow(true)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "nofollow", name: "robots" })
      end
    end

    it 'should display nofollow when "set_meta_tags" used' do
      subject.set_meta_tags(nofollow: true)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "nofollow", name: "robots" })
      end
    end

    it 'should use custom nofollow if given' do
      subject.nofollow('some-nofollow')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "nofollow", name: "some-nofollow" })
      end
    end

    it 'should display nothing by default' do
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to_not have_tag('meta', with: { content: "nofollow" })
      end
    end
  end

  context 'displaying both nofollow and noindex' do
    it 'should be displayed when set using helpers' do
      subject.noindex(true)
      subject.nofollow(true)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "noindex, nofollow", name: "robots" })
      end
    end

    it 'should be displayed when "set_meta_tags" used' do
      subject.set_meta_tags(nofollow: true, noindex: true)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "noindex, nofollow", name: "robots" })
      end
    end

    it 'should use custom name if string is used' do
      subject.noindex('some-name')
      subject.nofollow('some-name')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "noindex, nofollow", name: "some-name" })
      end
    end

    it 'should display two meta tags when different names used' do
      subject.noindex('some-noindex')
      subject.nofollow('some-nofollow')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "noindex", name: "some-noindex" })
        expect(meta).to have_tag('meta', with: { content: "nofollow", name: "some-nofollow" })
      end
    end
  end

  context 'displaying both follow and index' do
    it 'should be displayed when "set_meta_tags" used' do
      subject.set_meta_tags(follow: true, index: true)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "index, follow", name: "robots" })
      end
    end

    it 'should use custom name if string is used' do
      subject.set_meta_tags(follow: 'some-name123', index: 'some-name123')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "index, follow", name: "some-name123" })
      end
    end

    it 'should display two meta tags when different names used' do
      subject.set_meta_tags(follow: 'some-follow', index: 'some-index')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "index", name: "some-index" })
        expect(meta).to have_tag('meta', with: { content: "follow", name: "some-follow" })
      end
    end
  end

  context 'displaying both follow and noindex when nofollow and index set by mistake' do
    it 'should be displayed when "set_meta_tags" used' do
      subject.set_meta_tags(follow: true, index: true, nofollow: true, noindex: true)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "noindex, follow", name: "robots" })
      end
    end

    it 'should use custom name if string is used' do
      subject.set_meta_tags(follow: 'some-name', index: 'some-name', nofollow: 'some-name', noindex: 'some-name')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "noindex, follow", name: "some-name" })
      end
    end

    it 'should display two meta tags when different names used' do
      subject.set_meta_tags(follow: 'some-follow', index: 'some-index', nofollow: 'some-nofollow', noindex: 'some-noindex')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "index", name: "some-index" })
        expect(meta).to have_tag('meta', with: { content: "follow", name: "some-follow" })
        expect(meta).to have_tag('meta', with: { content: "noindex", name: "some-noindex" })
        expect(meta).to have_tag('meta', with: { content: "nofollow", name: "some-nofollow" })
      end
    end
  end

  context 'display noarchive' do
    it 'should display noarchive when "set_meta_tags" used' do
      subject.set_meta_tags(noarchive: true)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "noarchive", name: "robots" })
      end
    end

    it 'should display nothing if given false' do
      subject.set_meta_tags(noarchive: false)
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to_not have_tag('meta', with: { content: "noarchive", name: "robots" })
      end
    end

    it 'shoud use custom noarchive if given' do
      subject.set_meta_tags(noarchive: 'some-robots')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "noarchive", name: "some-robots" })
      end
    end
  end
end
