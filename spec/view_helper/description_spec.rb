require 'spec_helper'

describe MetaTags::ViewHelper, 'displaying description' do
  subject { ActionView::Base.new }

  it 'should not display description if blank' do
    subject.description('')
    expect(subject.display_meta_tags).to eq('')
  end

  it 'should display description when "description" used' do
    subject.description('someDescription')
    subject.display_meta_tags(:site => 'someSite').tap do |meta|
      expect(meta).to include('<meta content="someDescription" name="description" />')
    end
  end

  it 'should display description when "set_meta_tags" used' do
    subject.set_meta_tags(:description => 'someDescription')
    subject.display_meta_tags(:site => 'someSite').tap do |meta|
      expect(meta).to include('<meta content="someDescription" name="description" />')
    end
  end

  it 'should display default description' do
    subject.display_meta_tags(:site => 'someSite', :description => 'someDescription').tap do |meta|
      expect(meta).to include('<meta content="someDescription" name="description" />')
    end
  end

  it 'should use custom description if given' do
    subject.description('someDescription')
    subject.display_meta_tags(:site => 'someSite', :description => 'defaultDescription').tap do |meta|
      expect(meta).to include('<meta content="someDescription" name="description" />')
    end
  end

  it 'should strip multiple spaces' do
    subject.display_meta_tags(:site => 'someSite', :description => "some \n\r\t description").tap do |meta|
      expect(meta).to include('<meta content="some description" name="description" />')
    end
  end

  it 'should strip HTML' do
    subject.display_meta_tags(:site => 'someSite', :description => "<p>some <b>description</b></p>").tap do |meta|
      expect(meta).to include('<meta content="some description" name="description" />')
    end
  end

  it 'should change double quote to single quote' do
    subject.display_meta_tags(:site => 'someSite', :description => 'some "description"').tap do |meta|
      expect(meta).to include('<meta content="some &#39;description&#39;" name="description" />')
    end
  end

  it 'should truncate correctly' do
    subject.display_meta_tags(:site => 'someSite', :description => "Lorem ipsum dolor sit amet, consectetuer sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.").tap do |meta|
      expect(meta).to include('<meta content="Lorem ipsum dolor sit amet, consectetuer sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dol..." name="description" />')
    end
  end
end
