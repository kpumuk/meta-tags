# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MetaTags::ControllerHelper do
  subject do
    MetaTagsRailsApp::MetaTagsController.new.tap do |c|
      c.request = ActionDispatch::TestRequest.create
      c.response = ActionDispatch::TestResponse.new
    end
  end

  before do
    skip("Does not work properly with RBS") if ENV["RBS_TEST_TARGET"] # rubocop:disable RSpec/Pending
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

    it 'does not require instance variables' do
      subject.show
      expect(subject.response.body).to eq('_rendered_')
      expect(subject.meta_tags.meta_tags).to eq({})
    end

    it 'does not fail when instance variables are not set' do
      subject.hide
      expect(subject.response.body).to eq('_rendered_')
      expect(subject.meta_tags.meta_tags).to eq({})
    end
  end

  it_behaves_like '.set_meta_tags'
end
