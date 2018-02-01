# frozen_string_literal: true

require 'spec_helper'

describe MetaTags::ViewHelper, 'displaying description' do
  subject { ActionView::Base.new }

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
    subject.display_meta_tags(site: 'someSite', description: "Lorem ipsum dolor sit amet, consectetuer sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.").tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "Lorem ipsum dolor sit amet, consectetuer sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At", name: "description" })
    end
  end

  it 'treats nil as an empty string' do
    subject.display_meta_tags(description: nil).tap do |meta|
      expect(meta).to_not have_tag('meta', with: { name: "description" })
    end
  end

  it 'should allow objects that respond to #to_str' do
    description = double(to_str: 'some description')
    subject.display_meta_tags(description: description).tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "some description", name: "description" })
    end
  end

  it 'should fail when title is not a String-like object' do
    expect { subject.display_meta_tags(description: 5) }.to \
      raise_error ArgumentError, 'Expected a string or an object that implements #to_str'
  end
end
