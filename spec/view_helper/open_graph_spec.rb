require 'spec_helper'

describe MetaTags::ViewHelper, 'displaying Open Graph meta tags' do
  subject { ActionView::Base.new }

  it 'should display meta tags specified with :open_graph' do
    subject.set_meta_tags(open_graph: {
      title:       'Facebook Share Title',
      description: 'Facebook Share Description'
    })
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "Facebook Share Title", property: "og:title" })
      expect(meta).to have_tag('meta', with: { content: "Facebook Share Description", property: "og:description" })
    end
  end

  it 'should display meta tags specified with :og' do
    subject.set_meta_tags(og: {
      title:       'Facebook Share Title',
      description: 'Facebook Share Description'
    })
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "Facebook Share Title", property: "og:title" })
      expect(meta).to have_tag('meta', with: { content: "Facebook Share Description", property: "og:description" })
    end
  end

  it 'should use deep merge when displaying open graph meta tags' do
    subject.set_meta_tags(og: { title: 'Facebook Share Title' })
    subject.display_meta_tags(og: { description: 'Facebook Share Description' }).tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "Facebook Share Title", property: "og:title" })
      expect(meta).to have_tag('meta', with: { content: "Facebook Share Description", property: "og:description" })
    end
  end

  it "should not display meta tags without content" do
    subject.set_meta_tags(open_graph: {
      title:       '',
      description: ''
    })
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).to_not have_tag('meta', with: { content: "", property: "og:title" })
      expect(meta).to_not have_tag('meta', with: { content: "", property: "og:description" })
    end
  end

  it "should display locale meta tags" do
    subject.display_meta_tags(open_graph: { locale: { _: 'en_GB', alternate: ['fr_FR', 'es_ES'] } }).tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "en_GB", property: "og:locale" })
      expect(meta).to have_tag('meta', with: { content: "fr_FR", property: "og:locale:alternate" })
      expect(meta).to have_tag('meta', with: { content: "es_ES", property: "og:locale:alternate" })
    end
  end

  it "should display mirrored content" do
    subject.set_meta_tags(title: 'someTitle')
    subject.display_meta_tags(open_graph: { title: :title }).tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "someTitle", property: "og:title" })
    end
  end

  it "should display open graph meta tags with an array of images" do
    subject.set_meta_tags(open_graph: {
      title: 'someTitle',
      image: [{
        _:      'http://example.com/1.png',
        width:  75,
        height: 75,
      },
      {
        _:      'http://example.com/2.png',
        width:  50,
        height: 50,
      }]
    })
    subject.display_meta_tags(site: 'someTitle').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "someTitle", property: "og:title" })
      expect(meta).to have_tag('meta', with: { content: "http://example.com/1.png", property: "og:image" })
      expect(meta).to have_tag('meta', with: { content: "75", property: "og:image:width" })
      expect(meta).to have_tag('meta', with: { content: "75", property: "og:image:height" })
      expect(meta).to have_tag('meta', with: { content: "http://example.com/2.png", property: "og:image" })
      expect(meta).to have_tag('meta', with: { content: "50", property: "og:image:width" })
      expect(meta).to have_tag('meta', with: { content: "50", property: "og:image:height" })
    end
  end
end
