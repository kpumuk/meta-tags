require 'spec_helper'

describe MetaTags::ViewHelper do
  subject { ActionView::Base.new }

  context 'returning values' do
    it 'should return title' do
      subject.title('some-title').should eq('some-title')
    end

    it 'should return headline if specified' do
      subject.title('some-title', 'some-headline').should eq('some-headline')
    end

    it 'should return title' do
      subject.title('some-title').should eq('some-title')
      subject.title.should eq('some-title')
    end

    it 'should return description' do
      subject.description('some-description').should eq('some-description')
    end

    it 'should return keywords' do
      subject.keywords('some-keywords').should eq('some-keywords')
    end

    it 'should return noindex' do
      subject.noindex('some-noindex').should eq('some-noindex')
    end

    it 'should return nofollow' do
      subject.noindex('some-nofollow').should eq('some-nofollow')
    end
  end

  context 'while handling string meta tag names' do
    it 'should work with common parameters' do
      subject.display_meta_tags('site' => 'someSite', 'title' => 'someTitle').should eq('<title>someSite | someTitle</title>')
    end

    it 'should work with open graph parameters' do
      subject.set_meta_tags('og' => {
        'title'       => 'facebook title',
        'description' => 'facebook description'
      })
      subject.display_meta_tags(:site => 'someSite').tap do |content|
        content.should include('<meta content="facebook title" property="og:title" />')
        content.should include('<meta content="facebook description" property="og:description" />')
      end
    end
  end

  it_behaves_like '.set_meta_tags'
end
