require 'spec_helper'

describe MetaTags::ViewHelper, 'module' do
  subject { ActionView::Base.new }

  it 'should be mixed into ActionView::Base' do
    expect(ActionView::Base.included_modules).to include(MetaTags::ViewHelper)
  end

  it 'should respond to "title" helper' do
    expect(subject).to respond_to(:title)
  end

  it 'should respond to "description" helper' do
    expect(subject).to respond_to(:description)
  end

  it 'should respond to "keywords" helper' do
    expect(subject).to respond_to(:keywords)
  end

  it 'should respond to "noindex" helper' do
    expect(subject).to respond_to(:noindex)
  end

  it 'should respond to "nofollow" helper' do
    expect(subject).to respond_to(:nofollow)
  end

  it 'should respond to "set_meta_tags" helper' do
    expect(subject).to respond_to(:set_meta_tags)
  end

  it 'should respond to "display_meta_tags" helper' do
    expect(subject).to respond_to(:display_meta_tags)
  end

  it 'should respond to "display_title" helper' do
    expect(subject).to respond_to(:display_title)
  end
end
