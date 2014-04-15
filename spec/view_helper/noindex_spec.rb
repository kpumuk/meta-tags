require 'spec_helper'

describe MetaTags::ViewHelper do
  subject { ActionView::Base.new }

  context 'displaying noindex' do
    it 'should display noindex when "noindex" used' do
      subject.noindex(true)
      subject.display_meta_tags(:site => 'someSite').should include('<meta content="noindex" name="robots" />')
    end

    it 'should display noindex when "set_meta_tags" used' do
      subject.set_meta_tags(:noindex => true)
      subject.display_meta_tags(:site => 'someSite').should include('<meta content="noindex" name="robots" />')
    end

    it 'should use custom noindex if given' do
      subject.noindex('some-noindex')
      subject.display_meta_tags(:site => 'someSite').should include('<meta content="noindex" name="some-noindex" />')
    end

    it 'should display nothing by default' do
      subject.display_meta_tags(:site => 'someSite').should_not include('<meta content="noindex"')
    end

    it "should display nothing if given false" do
      subject.set_meta_tags(:noindex => false)
      subject.display_meta_tags(:site => 'someSite').should_not include('<meta content="robots"')
      subject.display_meta_tags(:site => 'someSite').should_not include('<meta content="noindex"')
    end
  end

  context 'displaying nofollow' do
    it 'should display nofollow when "nofollow" used' do
      subject.nofollow(true)
      subject.display_meta_tags(:site => 'someSite').should include('<meta content="nofollow" name="robots" />')
    end

    it 'should display nofollow when "set_meta_tags" used' do
      subject.set_meta_tags(:nofollow => true)
      subject.display_meta_tags(:site => 'someSite').should include('<meta content="nofollow" name="robots" />')
    end

    it 'should use custom nofollow if given' do
      subject.nofollow('some-nofollow')
      subject.display_meta_tags(:site => 'someSite').should include('<meta content="nofollow" name="some-nofollow" />')
    end

    it 'should display nothing by default' do
      subject.display_meta_tags(:site => 'someSite').should_not include('<meta content="nofollow"')
    end
  end

  context 'displaying both nofollow and noindex' do
    it 'should be displayed when set using helpers' do
      subject.noindex(true)
      subject.nofollow(true)
      subject.display_meta_tags(:site => 'someSite').should include('<meta content="noindex, nofollow" name="robots" />')
    end

    it 'should be displayed when "set_meta_tags" used' do
      subject.set_meta_tags(:nofollow => true, :noindex => true)
      subject.display_meta_tags(:site => 'someSite').should include('<meta content="noindex, nofollow" name="robots" />')
    end

    it 'should use custom name if string is used' do
      subject.noindex('some-name')
      subject.nofollow('some-name')
      subject.display_meta_tags(:site => 'someSite').should include('<meta content="noindex, nofollow" name="some-name" />')
    end

    it 'should display two meta tags when different names used' do
      subject.noindex('some-noindex')
      subject.nofollow('some-nofollow')
      subject.display_meta_tags(:site => 'someSite').tap do |content|
        content.should include('<meta content="noindex" name="some-noindex" />')
        content.should include('<meta content="nofollow" name="some-nofollow" />')
      end
    end
  end
end
