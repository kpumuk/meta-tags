require 'spec_helper'

class MetaTagsController < ActionController::Base
  attr_reader :rendered

  def render_without_meta_tags
    @rendered = true
  end

  def index
    @page_title       = 'title'
    @page_keywords    = 'key1, key2, key3'
    @page_description = 'description'
    render
  end

  public :set_meta_tags, :meta_tags
end

describe MetaTags::ControllerHelper do
  subject { MetaTagsController.new }

  context 'module' do
    it 'should be mixed into ActionController::Base' do
      expect(ActionController::Base.included_modules).to include(MetaTags::ControllerHelper)
    end

    it 'should respond to "set_meta_tags" helper' do
      expect(subject).to respond_to(:set_meta_tags)
    end
  end

  describe '.render' do
    it 'should set meta tags from instance variables' do
      subject.index
      expect(subject.rendered).to be_truthy
      expect(subject.meta_tags.meta_tags).to eq('title' => 'title', 'keywords' => 'key1, key2, key3', 'description' => 'description')
    end
  end

  it_behaves_like '.set_meta_tags'
end
