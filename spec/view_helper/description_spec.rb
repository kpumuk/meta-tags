# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MetaTags::ViewHelper, 'displaying description' do
  it 'does not display description if blank' do
    subject.description('')
    expect(subject.display_meta_tags).to eq('')
  end

  it 'displays description when "description" used' do
    subject.description('someDescription')
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "someDescription", name: "description" })
    end
  end

  it 'displays description when "set_meta_tags" used' do
    subject.set_meta_tags(description: 'someDescription')
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "someDescription", name: "description" })
    end
  end

  it 'displays default description' do
    subject.display_meta_tags(site: 'someSite', description: 'someDescription').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "someDescription", name: "description" })
    end
  end

  it 'uses custom description if given' do
    subject.description('someDescription')
    subject.display_meta_tags(site: 'someSite', description: 'defaultDescription').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "someDescription", name: "description" })
    end
  end

  it 'strips multiple spaces' do
    subject.display_meta_tags(site: 'someSite', description: "some \n\r\t description").tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "some description", name: "description" })
    end
  end

  it 'strips HTML' do
    subject.display_meta_tags(site: 'someSite', description: "<p>some <b>description</b></p>").tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "some description", name: "description" })
    end
  end

  it 'escapes double quotes' do
    subject.display_meta_tags(description: 'some "description"').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "some \"description\"", name: "description" })
    end
  end

  it 'escapes ampersands properly' do
    subject.display_meta_tags(description: 'verify & commit').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "verify & commit", name: "description" })
    end
  end

  it 'truncates correctly' do
    subject.display_meta_tags(site: 'someSite', description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam dolor lorem, lobortis quis faucibus id, tristique at lorem. Nullam sit amet mollis libero. Morbi ut sem malesuada massa faucibus vestibulum non sed quam. Duis quis consectetur lacus. Donec vitae nunc risus. Sed placerat semper elit, sit amet tristique dolor. Maecenas hendrerit volutpat.").tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam dolor lorem, lobortis quis faucibus id, tristique at lorem. Nullam sit amet mollis libero. Morbi ut sem malesuada massa faucibus vestibulum non sed quam. Duis quis consectetur lacus. Donec vitae nunc risus. Sed placerat semper elit, sit", name: "description" })
    end
  end

  it 'treats nil as an empty string' do
    subject.display_meta_tags(description: nil).tap do |meta|
      expect(meta).not_to have_tag('meta', with: { name: "description" })
    end
  end

  it 'allows objects that respond to #to_str' do
    description = double(to_str: 'some description')
    subject.display_meta_tags(description: description).tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "some description", name: "description" })
    end
  end

  it 'works with frozen strings' do
    allow(MetaTags::TextNormalizer).to receive(:strip_tags) { |s| s }
    subject.display_meta_tags(description: "some description").tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "some description", name: "description" })
    end
  end

  it 'fails when title is not a String-like object' do
    skip("Fails RBS") if ENV["RBS_TEST_TARGET"] # rubocop:disable RSpec/Pending

    expect {
      subject.display_meta_tags(description: 5)
    }.to raise_error ArgumentError, 'Expected a string or an object that implements #to_str'
  end
end
