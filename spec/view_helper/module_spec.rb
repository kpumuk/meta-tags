require 'spec_helper'

describe MetaTags::ViewHelper, 'module' do
  subject { ActionView::Base.new }

  it 'should be mixed into ActionView::Base' do
    ActionView::Base.included_modules.should include(MetaTags::ViewHelper)
  end

  it 'should respond to "title" helper' do
    subject.should respond_to(:title)
  end

  it 'should respond to "description" helper' do
    subject.should respond_to(:description)
  end

  it 'should respond to "keywords" helper' do
    subject.should respond_to(:keywords)
  end

  it 'should respond to "noindex" helper' do
    subject.should respond_to(:noindex)
  end

  it 'should respond to "nofollow" helper' do
    subject.should respond_to(:nofollow)
  end

  it 'should respond to "set_meta_tags" helper' do
    subject.should respond_to(:set_meta_tags)
  end

  it 'should respond to "display_meta_tags" helper' do
    subject.should respond_to(:display_meta_tags)
  end

  it 'should respond to "display_title" helper' do
    subject.should respond_to(:display_title)
  end
end
