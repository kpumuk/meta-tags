require 'spec_helper'

describe MetaTags::ViewHelper, 'displaying keywords' do
  subject { ActionView::Base.new }

  it 'should not display keywords if blank' do
    subject.keywords('')
    subject.display_meta_tags.should eq('')

    subject.keywords([])
    subject.display_meta_tags.should eq('')
  end

  it 'should display keywords when "keywords" used' do
    subject.keywords('some-keywords')
    subject.display_meta_tags(:site => 'someSite').should include('<meta content="some-keywords" name="keywords" />')
  end

  it 'should display keywords when "set_meta_tags" used' do
    subject.set_meta_tags(:keywords => 'some-keywords')
    subject.display_meta_tags(:site => 'someSite').should include('<meta content="some-keywords" name="keywords" />')
  end

  it 'should display default keywords' do
    subject.display_meta_tags(:site => 'someSite', :keywords => 'some-keywords').should include('<meta content="some-keywords" name="keywords" />')
  end

  it 'should use custom keywords if given' do
    subject.keywords('some-keywords')
    subject.display_meta_tags(:site => 'someSite', :keywords => 'default_keywords').should include('<meta content="some-keywords" name="keywords" />')
  end

  it 'should lowercase keywords' do
    subject.display_meta_tags(:site => 'someSite', :keywords => 'someKeywords').should include('<meta content="somekeywords" name="keywords" />')
  end

  it 'should join keywords from Array' do
    subject.display_meta_tags(:site => 'someSite', :keywords => %w(keyword1 keyword2)).should include('<meta content="keyword1, keyword2" name="keywords" />')
  end

  it 'should join keywords from nested Arrays' do
    subject.display_meta_tags(:site => 'someSite', :keywords => [%w(keyword1 keyword2), 'keyword3']).should include('<meta content="keyword1, keyword2, keyword3" name="keywords" />')
  end
end
