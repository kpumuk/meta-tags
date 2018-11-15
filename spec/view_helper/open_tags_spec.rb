# frozen_string_literal: true

require 'spec_helper'

describe MetaTags::ViewHelper, 'meta tags' do
  subject { ActionView::Base.new }

  context "with open_meta_tags=true" do
    it 'should generate open charset tag' do
      subject.display_meta_tags(charset: 'UTF-8').tap do |meta|
        expect(meta).to eq('<meta charset="UTF-8">')
      end
    end

    it 'should generate open meta tags' do
      subject.display_meta_tags(open_graph: { title: 'someSite' }).tap do |meta|
        expect(meta).to eq('<meta property="og:title" content="someSite">')
      end
    end

    it 'should generate open link tags' do
      subject.display_meta_tags(canonical: 'http://example.com/base/url').tap do |meta|
        expect(meta).to eq('<link rel="canonical" href="http://example.com/base/url">')
      end
    end
  end

  context "with open_meta_tags=false" do
    before :each do
      MetaTags.config.open_meta_tags = false
    end

    it 'should generate closed charset tag' do
      subject.display_meta_tags(charset: 'UTF-8').tap do |meta|
        expect(meta).to eq('<meta charset="UTF-8" />')
      end
    end

    it 'should generate closed meta tags' do
      subject.display_meta_tags(open_graph: { title: 'someSite' }).tap do |meta|
        expect(meta).to eq('<meta property="og:title" content="someSite" />')
      end
    end

    it 'should generate closed link tags' do
      subject.display_meta_tags(canonical: 'http://example.com/base/url').tap do |meta|
        expect(meta).to eq('<link rel="canonical" href="http://example.com/base/url" />')
      end
    end
  end
end
