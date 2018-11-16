# frozen_string_literal: true

require 'spec_helper'

describe MetaTags::ViewHelper do
  subject { ActionView::Base.new }

  describe 'displaying title' do
    it 'does not display title if blank' do
      expect(subject.display_meta_tags).to eq('')
      subject.title('')
      expect(subject.display_meta_tags).to eq('')
    end

    it 'uses website name if title is empty' do
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to eq('<title>someSite</title>')
      end
    end

    it 'displays title when "title" used' do
      subject.title('someTitle')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to eq('<title>someSite | someTitle</title>')
      end
    end

    it 'displays title only when "site" is empty' do
      subject.title('someTitle')
      expect(subject.display_meta_tags).to eq('<title>someTitle</title>')
    end

    it 'displays title when "set_meta_tags" is used' do
      subject.set_meta_tags(title: 'someTitle')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to eq('<title>someSite | someTitle</title>')
      end
    end

    it 'escapes the title when "set_meta_tags" is used' do
      subject.set_meta_tags(title: 'someTitle & somethingElse')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to eq('<title>someSite | someTitle &amp; somethingElse</title>')
      end
    end

    it 'escapes a very long title when "set_meta_tags" is used' do
      subject.set_meta_tags(title: 'Kombucha kale chips forage try-hard & green juice. IPhone marfa PBR&B venmo listicle, irony kitsch thundercats.')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to eq('<title>someSite | Kombucha kale chips forage try-hard &amp; green juice. IPhone</title>')
      end
    end

    it 'strips tags in the title' do
      subject.set_meta_tags(title: '<b>hackxor</b>')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to eq('<title>someSite | hackxor</title>')
      end
    end

    it 'strips tags from very long titles' do
      subject.set_meta_tags(title: 'Kombucha <b>kale</b> chips forage try-hard & green juice. IPhone marfa PBR&B venmo listicle, irony kitsch thundercats.')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to eq('<title>someSite | Kombucha kale chips forage try-hard &amp; green juice. IPhone</title>')
      end
    end

    it 'displays custom title if given' do
      subject.title('someTitle')
      subject.display_meta_tags(site: 'someSite', title: 'defaultTitle').tap do |meta|
        expect(meta).to eq('<title>someSite | someTitle</title>')
      end
    end

    it 'uses website before page by default' do
      subject.display_meta_tags(site: 'someSite', title: 'someTitle').tap do |meta|
        expect(meta).to eq('<title>someSite | someTitle</title>')
      end
    end

    it 'onlies use markup in titles in the view' do
      expect(subject.title('<b>someTitle</b>')).to eq('<b>someTitle</b>')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to eq('<title>someSite | someTitle</title>')
      end
    end

    it 'uses page before website if :reverse' do
      subject.display_meta_tags(site: 'someSite', title: 'someTitle', reverse: true).tap do |meta|
        expect(meta).to eq('<title>someTitle | someSite</title>')
      end
    end

    it 'is lowercase if :lowercase' do
      subject.display_meta_tags(site: 'someSite', title: 'someTitle', lowercase: true).tap do |meta|
        expect(meta).to eq('<title>someSite | sometitle</title>')
      end
    end

    it 'does not change original title string' do
      title = "TITLE"
      subject.display_meta_tags(title: title, lowercase: true).tap do |meta|
        expect(meta).to eq('<title>title</title>')
      end
      expect(title).to eq('TITLE')
    end

    # rubocop:disable Rails/OutputSafety
    it 'uses custom separator when :separator specified' do
      subject.title('someTitle')
      subject.display_meta_tags(site: 'someSite', separator: '-').tap do |meta|
        expect(meta).to eq('<title>someSite - someTitle</title>')
      end
      subject.display_meta_tags(site: 'someSite', separator: ':').tap do |meta|
        expect(meta).to eq('<title>someSite : someTitle</title>')
      end
      subject.display_meta_tags(site: 'someSite', separator: '&amp;').tap do |meta|
        expect(meta).to eq('<title>someSite &amp;amp; someTitle</title>')
      end
      subject.display_meta_tags(site: 'someSite', separator: '&').tap do |meta|
        expect(meta).to eq('<title>someSite &amp; someTitle</title>')
      end
      subject.display_meta_tags(site: 'someSite', separator: '&amp;'.html_safe).tap do |meta|
        expect(meta).to eq('<title>someSite &amp; someTitle</title>')
      end
      subject.display_meta_tags(site: 'someSite:', separator: false).tap do |meta|
        expect(meta).to eq('<title>someSite:someTitle</title>')
      end
    end
    # rubocop:enable Rails/OutputSafety

    it 'uses custom prefix and suffix if available' do
      subject.display_meta_tags(site: 'someSite', title: 'someTitle', prefix: ' -', suffix: '- ').tap do |meta|
        expect(meta).to eq('<title>someSite -|- someTitle</title>')
      end
    end

    it 'collapses prefix if false' do
      subject.display_meta_tags(site: 'someSite', title: 'someTitle', prefix: false).tap do |meta|
        expect(meta).to eq('<title>someSite| someTitle</title>')
      end
    end

    it 'collapses suffix if false' do
      subject.display_meta_tags(site: 'someSite', title: 'someTitle', suffix: false).tap do |meta|
        expect(meta).to eq('<title>someSite |someTitle</title>')
      end
    end

    it 'uses all custom options if available' do
      subject.display_meta_tags(
        site:      'someSite',
        title:     'someTitle',
        prefix:    ' -',
        suffix:    '+ ',
        separator: ':',
        lowercase: true,
        reverse:   true,
      ).tap do |meta|
        expect(meta).to eq('<title>sometitle -:+ someSite</title>')
      end
    end

    it 'allows Arrays in title' do
      subject.display_meta_tags(site: 'someSite', title: ['someTitle', 'anotherTitle']).tap do |meta|
        expect(meta).to eq('<title>someSite | someTitle | anotherTitle</title>')
      end
    end

    it 'allows Arrays in title with :lowercase' do
      subject.display_meta_tags(site: 'someSite', title: ['someTitle', 'anotherTitle'], lowercase: true).tap do |meta|
        expect(meta).to eq('<title>someSite | sometitle | anothertitle</title>')
      end
    end

    it 'treats nil as an empty string' do
      subject.display_meta_tags(title: nil).tap do |meta|
        expect(meta).not_to have_tag('title')
      end
    end

    it 'allows objects that respond to #to_str' do
      title = double(to_str: 'someTitle')
      subject.display_meta_tags(site: 'someSite', title: title).tap do |meta|
        expect(meta).to eq('<title>someSite | someTitle</title>')
      end
    end

    it 'fails when title is not a String-like object' do
      expect { subject.display_meta_tags(site: 'someSite', title: 5) }.to \
        raise_error ArgumentError, 'Expected a string or an object that implements #to_str'
    end

    it 'builds title in reverse order if :reverse' do
      subject.display_meta_tags(
        site:      'someSite',
        title:     ['someTitle', 'anotherTitle'],
        prefix:    ' -',
        suffix:    '+ ',
        separator: ':',
        reverse:   true,
      ).tap do |meta|
        expect(meta).to eq('<title>anotherTitle -:+ someTitle -:+ someSite</title>')
      end
    end

    it 'minifies the output when asked to' do
      subject.display_meta_tags(title: 'hello', description: 'world').tap do |meta|
        expect(meta).to eq("<title>hello</title>\n<meta name=\"description\" content=\"world\">")
      end

      MetaTags.config.minify_output = true
      subject.display_meta_tags(title: 'hello', description: 'world').tap do |meta|
        expect(meta).to eq("<title>hello</title><meta name=\"description\" content=\"world\">")
      end
    end
  end

  describe '.display_title' do
    it 'displays custom title if given' do
      subject.title('someTitle')
      subject.display_title(site: 'someSite', title: 'defaultTitle').tap do |meta|
        expect(meta).to eq('someSite | someTitle')
      end
    end
  end
end
