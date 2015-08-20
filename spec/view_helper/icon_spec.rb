require 'spec_helper'

describe MetaTags::ViewHelper do
  subject { ActionView::Base.new }

  it 'should not display icon by default' do
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).to_not have_tag('link', with: { rel: 'icon' })
    end
  end

  it 'should display icon when "set_meta_tags" used' do
    subject.set_meta_tags(icon: '/favicon.ico')
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).to have_tag('link', with: { href: '/favicon.ico', rel: 'icon', type: 'image/x-icon' })
    end
  end

  it 'should display default canonical url' do
    subject.display_meta_tags(site: 'someSite', icon: '/favicon.ico').tap do |meta|
      expect(meta).to have_tag('link', with: { href: '/favicon.ico', rel: 'icon', type: 'image/x-icon' })
    end
  end

  it 'should allow to specify hash as an icon' do
    subject.set_meta_tags(icon: { href: '/favicon.png', type: 'image/png' })
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).to have_tag('link', with: { href: '/favicon.png', rel: 'icon', type: 'image/png' })
    end
  end

  it 'should allow to specify multiple icons' do
    subject.set_meta_tags(icon: [
      { href: '/images/icons/icon_96.png', sizes: '32x32 96x96', type: 'image/png' },
      { href: '/images/icons/icon_itouch_precomp_32.png', rel: 'apple-touch-icon-precomposed', sizes: '32x32', type: 'image/png' },
    ])
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).to have_tag('link', with: { href: '/images/icons/icon_96.png', rel: 'icon', type: 'image/png', sizes: '32x32 96x96' })
      expect(meta).to have_tag('link', with: { href: '/images/icons/icon_itouch_precomp_32.png', rel: 'apple-touch-icon-precomposed', type: 'image/png', sizes: '32x32' })
    end
  end
end
