require 'spec_helper'

describe MetaTags::ViewHelper, 'displaying refresh' do
  subject { ActionView::Base.new }

  it 'displays refresh when "refresh" is used' do
    subject.refresh(5)
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: '5', 'http-equiv' => 'refresh' })
    end
  end

  it 'displays refresh when "set_meta_tags" used' do
    subject.set_meta_tags(refresh: 5)
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: '5', 'http-equiv' => 'refresh' })
    end
  end

  it 'should use custom refresh if given' do
    subject.refresh("5;url=http://example.com/")
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: '5;url=http://example.com/', 'http-equiv' => "refresh" })
    end
  end

  it 'should display nothing by default' do
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).to_not have_tag('meta', with: { 'http-equiv' => "refresh" })
    end
  end
end
