require 'spec_helper'

describe MetaTags::ViewHelper do
  subject { ActionView::Base.new }

  context 'displaying title' do
    it 'should not display title if blank' do
      expect(subject.display_meta_tags).to eq('')
      subject.title('')
      expect(subject.display_meta_tags).to eq('')
    end

    it 'should use website name if title is empty' do
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to eq('<title>someSite</title>')
      end
    end

    it 'should display title when "title" used' do
      subject.title('someTitle')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to eq('<title>someSite | someTitle</title>')
      end
    end

    it 'should display title only when "site" is empty' do
      subject.title('someTitle')
      expect(subject.display_meta_tags).to eq('<title>someTitle</title>')
    end

    it 'should display title when "set_meta_tags" used' do
      subject.set_meta_tags(title: 'someTitle')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to eq('<title>someSite | someTitle</title>')
      end
    end

    it 'should display custom title if given' do
      subject.title('someTitle')
      subject.display_meta_tags(site: 'someSite', title: 'defaultTitle').tap do |meta|
        expect(meta).to eq('<title>someSite | someTitle</title>')
      end
    end

    it 'should use website before page by default' do
      subject.display_meta_tags(site: 'someSite', title: 'someTitle').tap do |meta|
        expect(meta).to eq('<title>someSite | someTitle</title>')
      end
    end

    it 'should only use markup in titles in the view' do
      expect(subject.title('<b>someTitle</b>')).to eq('<b>someTitle</b>')
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to eq('<title>someSite | someTitle</title>')
      end
    end

    it 'should use page before website if :reverse' do
      subject.display_meta_tags(site: 'someSite', title: 'someTitle', reverse: true).tap do |meta|
        expect(meta).to eq('<title>someTitle | someSite</title>')
      end
    end

    it 'should be lowercase if :lowercase' do
      subject.display_meta_tags(site: 'someSite', title: 'someTitle', lowercase: true).tap do |meta|
        expect(meta).to eq('<title>someSite | sometitle</title>')
      end
    end

    it 'should use custom separator if :separator' do
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
      subject.display_meta_tags(site: 'someSite', separator: '&amp;'.html_safe).tap do |meta|
        expect(meta).to eq('<title>someSite &amp; someTitle</title>')
      end
      subject.display_meta_tags(site: 'someSite: ', separator: false).tap do |meta|
        expect(meta).to eq('<title>someSite: someTitle</title>')
      end
    end

    it 'should use custom prefix and suffix if available' do
      subject.display_meta_tags(site: 'someSite', title: 'someTitle', prefix: ' -', suffix: '- ').tap do |meta|
        expect(meta).to eq('<title>someSite -|- someTitle</title>')
      end
    end

    it 'should collapse prefix if false' do
      subject.display_meta_tags(site: 'someSite', title: 'someTitle', prefix: false).tap do |meta|
        expect(meta).to eq('<title>someSite| someTitle</title>')
      end
    end

    it 'should collapse suffix if false' do
      subject.display_meta_tags(site: 'someSite', title: 'someTitle', suffix: false).tap do |meta|
        expect(meta).to eq('<title>someSite |someTitle</title>')
      end
    end

    it 'should use all custom options if available' do
      subject.display_meta_tags({
        site:      'someSite',
        title:     'someTitle',
        prefix:    ' -',
        suffix:    '+ ',
        separator: ':',
        lowercase: true,
        reverse:   true,
      }).tap do |meta|
        expect(meta).to eq('<title>sometitle -:+ someSite</title>')
      end
    end

    it 'should allow Arrays in title' do
      subject.display_meta_tags(site: 'someSite', title: ['someTitle', 'anotherTitle']).tap do |meta|
        expect(meta).to eq('<title>someSite | someTitle | anotherTitle</title>')
      end
    end

    it 'should allow Arrays in title with :lowercase' do
      subject.display_meta_tags(site: 'someSite', title: ['someTitle', 'anotherTitle'], lowercase: true).tap do |meta|
        expect(meta).to eq('<title>someSite | sometitle | anothertitle</title>')
      end
    end

    it 'should build title in reverse order if :reverse' do
      subject.display_meta_tags({
        site:      'someSite',
        title:     ['someTitle', 'anotherTitle'],
        prefix:    ' -',
        suffix:    '+ ',
        separator: ':',
        reverse:   true,
      }).tap do |meta|
        expect(meta).to eq('<title>anotherTitle -:+ someTitle -:+ someSite</title>')
      end
    end
  end

  context '.display_title' do
    it 'should display custom title if given' do
      subject.title('someTitle')
      subject.display_title(site: 'someSite', title: 'defaultTitle').tap do |meta|
        expect(meta).to eq('someSite | someTitle')
      end
    end
  end
end
