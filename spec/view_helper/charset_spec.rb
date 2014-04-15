require 'spec_helper'

describe MetaTags::ViewHelper, 'displaying charset' do
  subject { ActionView::Base.new }

  it 'should not display charset if blank' do
    subject.display_meta_tags.should eq('')
    subject.display_meta_tags(:charset => '').should eq('')
  end

  it 'should display charset' do
    subject.display_meta_tags(:charset => 'UTF-8').should eq('<meta charset="UTF-8" />')
  end
end
