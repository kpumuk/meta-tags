require 'spec_helper'

describe MetaTags::ViewHelper, 'displaying description' do
  subject { ActionView::Base.new }

  it 'should not display description if blank' do
    subject.description('')
    subject.display_meta_tags.should eq('')
  end

  it 'should display description when "description" used' do
    subject.description('someDescription')
    subject.display_meta_tags(:site => 'someSite').should include('<meta content="someDescription" name="description" />')
  end

  it 'should display description when "set_meta_tags" used' do
    subject.set_meta_tags(:description => 'someDescription')
    subject.display_meta_tags(:site => 'someSite').should include('<meta content="someDescription" name="description" />')
  end

  it 'should display default description' do
    subject.display_meta_tags(:site => 'someSite', :description => 'someDescription').should include('<meta content="someDescription" name="description" />')
  end

  it 'should use custom description if given' do
    subject.description('someDescription')
    subject.display_meta_tags(:site => 'someSite', :description => 'defaultDescription').should include('<meta content="someDescription" name="description" />')
  end

  it 'should strip multiple spaces' do
    subject.display_meta_tags(:site => 'someSite', :description => "some \n\r\t description").should include('<meta content="some description" name="description" />')
  end

  it 'should strip HTML' do
    subject.display_meta_tags(:site => 'someSite', :description => "<p>some <b>description</b></p>").should include('<meta content="some description" name="description" />')
  end

  it 'should truncate correctly' do
    subject.display_meta_tags(:site => 'someSite', :description => "Lorem ipsum dolor sit amet, consectetuer sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.").should include('<meta content="Lorem ipsum dolor sit amet, consectetuer sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dol..." name="description" />')
  end
end
