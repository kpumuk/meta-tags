require 'spec_helper'

describe MetaTags::ViewHelper, 'displaying Facebook meta tags' do
  subject { ActionView::Base.new }

  it 'should display meta tags specified with :open_graph' do
    subject.set_meta_tags(fb: {
      app_id: 12345
    })
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "12345", property: "fb:app_id" })
    end
  end
end
