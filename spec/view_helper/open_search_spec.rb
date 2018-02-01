require 'spec_helper'

describe MetaTags::ViewHelper, 'displaying Open Search meta tags' do
  subject { ActionView::Base.new }

  it 'displays meta tags specified with :open_search' do
    subject.set_meta_tags(
      open_search: {
        title: 'Open Search Title',
        href:  '/open_search_path.xml',
      },
    )
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).to have_tag(
        'link',
        with: {
          href:  '/open_search_path.xml',
          rel:   'search',
          title: 'Open Search Title',
          type:  'application/opensearchdescription+xml',
        },
      )
    end
  end

  it 'does not display meta tags without content' do
    subject.set_meta_tags(
      open_search: {
        title: '',
        href:  '',
      },
    )
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).not_to have_tag(
        'link',
        with: {
          rel:   'search',
          type:  'application/opensearchdescription+xml',
        },
      )
    end
  end
end
