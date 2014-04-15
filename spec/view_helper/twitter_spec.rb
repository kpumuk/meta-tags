require 'spec_helper'

describe MetaTags::ViewHelper, 'displaying Twitter meta tags' do
  subject { ActionView::Base.new }

  it 'should display meta tags specified with :twitter' do
    subject.set_meta_tags(:twitter => {
      :title => 'Twitter Share Title',
      :card  => 'photo',
      :image => {
        :_      => 'http://example.com/1.png',
        :width  => 123,
        :height => 321,
      }
    })
    subject.display_meta_tags(:site => 'someSite').tap do |meta|
      expect(meta).to include('<meta content="Twitter Share Title" name="twitter:title" />')
      expect(meta).to include('<meta content="photo" name="twitter:card" />')
      expect(meta).to include('<meta content="http://example.com/1.png" name="twitter:image" />')
      expect(meta).to include('<meta content="123" name="twitter:image:width" />')
      expect(meta).to include('<meta content="321" name="twitter:image:height" />')
    end
  end

  it "should display mirrored content" do
    subject.set_meta_tags(:title => 'someTitle')
    subject.display_meta_tags(:twitter => { :title => :title }).tap do |meta|
      expect(meta).to include('<meta content="someTitle" name="twitter:title" />')
    end
  end
end
