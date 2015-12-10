require 'spec_helper'

describe MetaTags::ViewHelper, 'displaying Applinks meta tags' do
  subject { ActionView::Base.new }

  it 'should display meta tags specified with :al' do
    subject.set_meta_tags(al: {
      foo:       'bar',
    })
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "bar", property: "al:foo" })
    end
  end

  it 'should use deep merge when displaying open graph meta tags' do
    subject.set_meta_tags(al: { foo: 'bar' })
    subject.display_meta_tags(al: { fooo: 'baar' }).tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "bar", property: "al:foo" })
      expect(meta).to have_tag('meta', with: { content: "baar", property: "al:fooo" })
    end
  end

  it "should not display meta tags without content" do
    subject.set_meta_tags(al: {
      title:       '',
      description: ''
    })
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).to_not have_tag('meta', with: { content: "", property: "al:title" })
      expect(meta).to_not have_tag('meta', with: { content: "", property: "al:description" })
    end
  end

end
