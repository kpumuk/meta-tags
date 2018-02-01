require 'spec_helper'

class MetaTagsController < ActionController::Base
  def index
    @page_title       = 'title'
    @page_keywords    = 'key1, key2, key3'
    @page_description = 'description'

    if Gem.loaded_specs["actionpack"].version > Gem::Version.new('4.2.0')
      render plain: '_rendered_'
    else
      render text: '_rendered_'
    end
  end

  public :set_meta_tags, :meta_tags
end

describe MetaTags::ControllerHelper do
  subject do
    MetaTagsController.new.tap do |c|
      c.response = ActionDispatch::TestResponse.new
    end
  end

  describe 'module' do
    it 'is mixed into ActionController::Base' do
      expect(ActionController::Base.included_modules).to include(described_class)
    end

    it 'responds to "set_meta_tags" helper' do
      expect(subject).to respond_to(:set_meta_tags)
    end
  end

  describe '.render' do
    it 'sets meta tags from instance variables' do
      subject.index
      expect(subject.response.body).to eq('_rendered_')
      expect(subject.meta_tags.meta_tags).to eq('title' => 'title', 'keywords' => 'key1, key2, key3', 'description' => 'description')
    end
  end

  it_behaves_like '.set_meta_tags'
end
