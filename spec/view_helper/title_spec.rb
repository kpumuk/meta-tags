require 'spec_helper'

describe MetaTags::ViewHelper do
  subject { ActionView::Base.new }

  context 'displaying title' do
    it 'should not display title if blank' do
      subject.display_meta_tags.should eq('')
      subject.title('')
      subject.display_meta_tags.should eq('')
    end

    it 'should use website name if title is empty' do
      subject.display_meta_tags(:site => 'someSite').should eq('<title>someSite</title>')
    end

    it 'should display title when "title" used' do
      subject.title('someTitle')
      subject.display_meta_tags(:site => 'someSite').should eq('<title>someSite | someTitle</title>')
    end

    it 'should display title only when "site" is empty' do
      subject.title('someTitle')
      subject.display_meta_tags.should eq('<title>someTitle</title>')
    end

    it 'should display title when "set_meta_tags" used' do
      subject.set_meta_tags(:title => 'someTitle')
      subject.display_meta_tags(:site => 'someSite').should eq('<title>someSite | someTitle</title>')
    end

    it 'should display custom title if given' do
      subject.title('someTitle')
      subject.display_meta_tags(:site => 'someSite', :title => 'defaultTitle').should eq('<title>someSite | someTitle</title>')
    end

    it 'should use website before page by default' do
      subject.display_meta_tags(:site => 'someSite', :title => 'someTitle').should eq('<title>someSite | someTitle</title>')
    end

    it 'should only use markup in titles in the view' do
      subject.title('<b>someTitle</b>').should eq('<b>someTitle</b>')
      subject.display_meta_tags(:site => 'someSite').should eq('<title>someSite | someTitle</title>')
    end

    it 'should use page before website if :reverse' do
      subject.display_meta_tags(:site => 'someSite', :title => 'someTitle', :reverse => true).should eq('<title>someTitle | someSite</title>')
    end

    it 'should be lowercase if :lowercase' do
      subject.display_meta_tags(:site => 'someSite', :title => 'someTitle', :lowercase => true).should eq('<title>someSite | sometitle</title>')
    end

    it 'should use custom separator if :separator' do
      subject.title('someTitle')
      subject.display_meta_tags(:site => 'someSite', :separator => '-').should eq('<title>someSite - someTitle</title>')
      subject.display_meta_tags(:site => 'someSite', :separator => ':').should eq('<title>someSite : someTitle</title>')
      subject.display_meta_tags(:site => 'someSite', :separator => '&mdash;').should eq('<title>someSite &amp;mdash; someTitle</title>')
      subject.display_meta_tags(:site => 'someSite', :separator => '&mdash;'.html_safe).should eq('<title>someSite &mdash; someTitle</title>')
      subject.display_meta_tags(:site => 'someSite: ', :separator => false).should eq('<title>someSite: someTitle</title>')
    end

    it 'should use custom prefix and suffix if available' do
      subject.display_meta_tags(:site => 'someSite', :title => 'someTitle', :prefix => ' -', :suffix => '- ').should eq('<title>someSite -|- someTitle</title>')
    end

    it 'should collapse prefix if false' do
      subject.display_meta_tags(:site => 'someSite', :title => 'someTitle', :prefix => false).should eq('<title>someSite| someTitle</title>')
    end

    it 'should collapse suffix if false' do
      subject.display_meta_tags(:site => 'someSite', :title => 'someTitle', :suffix => false).should eq('<title>someSite |someTitle</title>')
    end

    it 'should use all custom options if available' do
      subject.display_meta_tags(:site => 'someSite',
                              :title => 'someTitle',
                              :prefix => ' -',
                              :suffix => '+ ',
                              :separator => ':',
                              :lowercase => true,
                              :reverse => true).should eq('<title>sometitle -:+ someSite</title>')
    end

    it 'should allow Arrays in title' do
      subject.display_meta_tags(:site => 'someSite', :title => ['someTitle', 'anotherTitle']).should eq('<title>someSite | someTitle | anotherTitle</title>')
    end

    it 'should allow Arrays in title with :lowercase' do
      subject.display_meta_tags(:site => 'someSite', :title => ['someTitle', 'anotherTitle'], :lowercase => true).should eq('<title>someSite | sometitle | anothertitle</title>')
    end

    it 'should build title in reverse order if :reverse' do
      subject.display_meta_tags(:site => 'someSite',
                              :title => ['someTitle', 'anotherTitle'],
                              :prefix => ' -',
                              :suffix => '+ ',
                              :separator => ':',
                              :reverse => true).should eq('<title>anotherTitle -:+ someTitle -:+ someSite</title>')
    end
  end

  context '.display_title' do
    it 'should display custom title if given' do
      subject.title('someTitle')
      subject.display_title(:site => 'someSite', :title => 'defaultTitle').should eq('someSite | someTitle')
    end
  end
end
