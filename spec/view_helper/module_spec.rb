# frozen_string_literal: true

require "spec_helper"

RSpec.describe MetaTags::ViewHelper, "module" do
  it "registers the MetaTags deprecator with Rails" do
    skip "Rails.application.deprecators requires Rails 7.1+" unless Rails.application.respond_to?(:deprecators)

    expect(Rails.application.deprecators[:meta_tags]).to be(MetaTags.deprecator)
  end

  it "is mixed into ActionView::Base" do
    expect(ActionView::Base.included_modules).to include(described_class)
  end

  it 'responds to "title" helper' do
    expect(subject).to respond_to(:title)
  end

  it 'responds to "description" helper' do
    expect(subject).to respond_to(:description)
  end

  it 'responds to "keywords" helper' do
    expect(subject).to respond_to(:keywords)
  end

  it 'responds to "noindex" helper' do
    expect(subject).to respond_to(:noindex)
  end

  it 'responds to "nofollow" helper' do
    expect(subject).to respond_to(:nofollow)
  end

  it 'responds to "set_meta_tags" helper' do
    expect(subject).to respond_to(:set_meta_tags)
  end

  it 'responds to "display_meta_tags" helper' do
    expect(subject).to respond_to(:display_meta_tags)
  end

  it 'responds to "display_title" helper' do
    expect(subject).to respond_to(:display_title)
  end
end
