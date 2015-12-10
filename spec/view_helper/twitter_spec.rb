require 'spec_helper'

describe MetaTags::ViewHelper, 'displaying Twitter meta tags' do
  subject { ActionView::Base.new }

  it 'should display meta tags specified with :twitter' do
    subject.set_meta_tags(twitter: {
      title: 'Twitter Share Title',
      card:  'photo',
      image: {
        _:      'http://example.com/1.png',
        width:  123,
        height: 321,
      }
    })
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "Twitter Share Title", property: "twitter:title" })
      expect(meta).to have_tag('meta', with: { content: "photo", property: "twitter:card" })
      expect(meta).to have_tag('meta', with: { content: "http://example.com/1.png", property: "twitter:image" })
      expect(meta).to have_tag('meta', with: { content: "123", property: "twitter:image:width" })
      expect(meta).to have_tag('meta', with: { content: "321", property: "twitter:image:height" })
    end
  end

  it "should display mirrored content" do
    subject.set_meta_tags(title: 'someTitle')
    subject.display_meta_tags(twitter: { title: :title }).tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "someTitle", property: "twitter:title" })
    end
  end
end
