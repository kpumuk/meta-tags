require 'spec_helper'

describe MetaTags::ViewHelper, 'displaying charset' do
  subject { ActionView::Base.new }

  it 'does not display charset if blank' do
    expect(subject.display_meta_tags).to eq('')
    expect(subject.display_meta_tags(charset: '')).to eq('')
  end

  it 'displays charset' do
    subject.display_meta_tags(charset: 'UTF-8').tap do |meta|
      expect(meta).to eq('<meta charset="UTF-8">')
    end
  end
end
