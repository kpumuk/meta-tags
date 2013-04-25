require 'spec_helper'

describe MetaTags::ViewHelper do
  subject { ActionView::Base.new }

  context 'module' do
    it 'should be mixed into ActionView::Base' do
      ActionView::Base.included_modules.should include(MetaTags::ViewHelper)
    end

    it 'should respond to "title" helper' do
      subject.should respond_to(:title)
    end

    it 'should respond to "description" helper' do
      subject.should respond_to(:description)
    end

    it 'should respond to "keywords" helper' do
      subject.should respond_to(:keywords)
    end

    it 'should respond to "noindex" helper' do
      subject.should respond_to(:noindex)
    end

    it 'should respond to "nofollow" helper' do
      subject.should respond_to(:nofollow)
    end

    it 'should respond to "set_meta_tags" helper' do
      subject.should respond_to(:set_meta_tags)
    end

    it 'should respond to "display_meta_tags" helper' do
      subject.should respond_to(:display_meta_tags)
    end

    it 'should respond to "display_title" helper' do
      subject.should respond_to(:display_title)
    end
  end

  context 'returning values' do
    it 'should return title' do
      subject.title('some-title').should eq('some-title')
    end

    it 'should return headline if specified' do
      subject.title('some-title', 'some-headline').should eq('some-headline')
    end

    it 'should return title' do
      subject.title('some-title').should eq('some-title')
      subject.title.should eq('some-title')
    end

    it 'should return description' do
      subject.description('some-description').should eq('some-description')
    end

    it 'should return keywords' do
      subject.keywords('some-keywords').should eq('some-keywords')
    end

    it 'should return noindex' do
      subject.noindex('some-noindex').should eq('some-noindex')
    end

    it 'should return nofollow' do
      subject.noindex('some-nofollow').should eq('some-nofollow')
    end
  end

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

    it 'shold allow Arrays in title' do
      subject.display_meta_tags(:site => 'someSite', :title => ['someTitle', 'anotherTitle']).should eq('<title>someSite | someTitle | anotherTitle</title>')
    end

    it 'shold allow Arrays in title with :lowercase' do
      subject.display_meta_tags(:site => 'someSite', :title => ['someTitle', 'anotherTitle'], :lowercase => true).should eq('<title>someSite | sometitle | anothertitle</title>')
    end

    it 'shold build title in reverse order if :reverse' do
      subject.display_meta_tags(:site => 'someSite',
                              :title => ['someTitle', 'anotherTitle'],
                              :prefix => ' -',
                              :suffix => '+ ',
                              :separator => ':',
                              :reverse => true).should eq('<title>anotherTitle -:+ someTitle -:+ someSite</title>')
    end
  end

  context 'displaying description' do
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

  context 'displaying keywords' do
    it 'should not display keywords if blank' do
      subject.keywords('')
      subject.display_meta_tags.should eq('')

      subject.keywords([])
      subject.display_meta_tags.should eq('')
    end

    it 'should display keywords when "keywords" used' do
      subject.keywords('some-keywords')
      subject.display_meta_tags(:site => 'someSite').should include('<meta content="some-keywords" name="keywords" />')
    end

    it 'should display keywords when "set_meta_tags" used' do
      subject.set_meta_tags(:keywords => 'some-keywords')
      subject.display_meta_tags(:site => 'someSite').should include('<meta content="some-keywords" name="keywords" />')
    end

    it 'should display default keywords' do
      subject.display_meta_tags(:site => 'someSite', :keywords => 'some-keywords').should include('<meta content="some-keywords" name="keywords" />')
    end

    it 'should use custom keywords if given' do
      subject.keywords('some-keywords')
      subject.display_meta_tags(:site => 'someSite', :keywords => 'default_keywords').should include('<meta content="some-keywords" name="keywords" />')
    end

    it 'should lowercase keywords' do
      subject.display_meta_tags(:site => 'someSite', :keywords => 'someKeywords').should include('<meta content="somekeywords" name="keywords" />')
    end

    it 'should join keywords from Array' do
      subject.display_meta_tags(:site => 'someSite', :keywords => %w(keyword1 keyword2)).should include('<meta content="keyword1, keyword2" name="keywords" />')
    end

    it 'should join keywords from nested Arrays' do
      subject.display_meta_tags(:site => 'someSite', :keywords => [%w(keyword1 keyword2), 'keyword3']).should include('<meta content="keyword1, keyword2, keyword3" name="keywords" />')
    end
  end

  context 'displaying refresh' do
    it 'displays refresh when "refresh" is used' do
      subject.refresh(5)
      subject.display_meta_tags(:site => 'someSite').should include('<meta content="5" http-equiv="refresh" />')
    end

    it 'displays refresh when "set_meta_tags" used' do
      subject.set_meta_tags(:refresh => 5)
      subject.display_meta_tags(:site => 'someSite').should include('<meta content="5" http-equiv="refresh" />')
    end

    it 'should use custom refresh if given' do
      subject.refresh("5;URL='http://example.com/'")
      subject.display_meta_tags(:site => 'someSite').should include(%Q{<meta content="5;URL='http://example.com/'" http-equiv="refresh" />})
    end

    it 'should display nothing by default' do
      subject.display_meta_tags(:site => 'someSite').should_not include('http-equiv="refresh"')
    end
  end

  context 'displaying noindex' do
    it 'should display noindex when "noindex" used' do
      subject.noindex(true)
      subject.display_meta_tags(:site => 'someSite').should include('<meta content="noindex" name="robots" />')
    end

    it 'should display noindex when "set_meta_tags" used' do
      subject.set_meta_tags(:noindex => true)
      subject.display_meta_tags(:site => 'someSite').should include('<meta content="noindex" name="robots" />')
    end

    it 'should use custom noindex if given' do
      subject.noindex('some-noindex')
      subject.display_meta_tags(:site => 'someSite').should include('<meta content="noindex" name="some-noindex" />')
    end

    it 'should display nothing by default' do
      subject.display_meta_tags(:site => 'someSite').should_not include('<meta content="noindex"')
    end

    it "should display nothing if given false" do
      subject.set_meta_tags(:noindex => false)
      subject.display_meta_tags(:site => 'someSite').should_not include('<meta content="robots"')
      subject.display_meta_tags(:site => 'someSite').should_not include('<meta content="noindex"')
    end
  end

  context 'displaying nofollow' do
    it 'should display nofollow when "nofollow" used' do
      subject.nofollow(true)
      subject.display_meta_tags(:site => 'someSite').should include('<meta content="nofollow" name="robots" />')
    end

    it 'should display nofollow when "set_meta_tags" used' do
      subject.set_meta_tags(:nofollow => true)
      subject.display_meta_tags(:site => 'someSite').should include('<meta content="nofollow" name="robots" />')
    end

    it 'should use custom nofollow if given' do
      subject.nofollow('some-nofollow')
      subject.display_meta_tags(:site => 'someSite').should include('<meta content="nofollow" name="some-nofollow" />')
    end

    it 'should display nothing by default' do
      subject.display_meta_tags(:site => 'someSite').should_not include('<meta content="nofollow"')
    end
  end

  context 'displaying both nofollow and noindex' do
    it 'should be displayed when set using helpers' do
      subject.noindex(true)
      subject.nofollow(true)
      subject.display_meta_tags(:site => 'someSite').should include('<meta content="noindex, nofollow" name="robots" />')
    end

    it 'should be displayed when "set_meta_tags" used' do
      subject.set_meta_tags(:nofollow => true, :noindex => true)
      subject.display_meta_tags(:site => 'someSite').should include('<meta content="noindex, nofollow" name="robots" />')
    end

    it 'should use custom name if string is used' do
      subject.noindex('some-name')
      subject.nofollow('some-name')
      subject.display_meta_tags(:site => 'someSite').should include('<meta content="noindex, nofollow" name="some-name" />')
    end

    it 'should display two meta tags when different names used' do
      subject.noindex('some-noindex')
      subject.nofollow('some-nofollow')
      subject.display_meta_tags(:site => 'someSite').tap do |content|
        content.should include('<meta content="noindex" name="some-noindex" />')
        content.should include('<meta content="nofollow" name="some-nofollow" />')
      end
    end
  end

  context 'displaying canonical url' do
    it 'should not display canonical url by default' do
      subject.display_meta_tags(:site => 'someSite').should_not include('<link href="http://example.com/base/url" rel="canonical" />')
    end

    it 'should display canonical url when "set_meta_tags" used' do
      subject.set_meta_tags(:canonical => 'http://example.com/base/url')
      subject.display_meta_tags(:site => 'someSite').should include('<link href="http://example.com/base/url" rel="canonical" />')
    end

    it 'should display default canonical url' do
      subject.display_meta_tags(:site => 'someSite', :canonical => 'http://example.com/base/url').should include('<link href="http://example.com/base/url" rel="canonical" />')
    end
  end

  context 'displaying Open Graph meta tags' do
    it 'should display meta tags specified with :open_graph' do
      subject.set_meta_tags(:open_graph => {
        :title       => 'Facebook Share Title',
        :description => 'Facebook Share Description'
      })
      subject.display_meta_tags(:site => 'someSite').tap do |content|
        content.should include('<meta content="Facebook Share Title" property="og:title" />')
        content.should include('<meta content="Facebook Share Description" property="og:description" />')
      end
    end

    it 'should display meta tags specified with :og' do
      subject.set_meta_tags(:og => {
        :title       => 'Facebook Share Title',
        :description => 'Facebook Share Description'
      })
      subject.display_meta_tags(:site => 'someSite').tap do |content|
        content.should include('<meta content="Facebook Share Title" property="og:title" />')
        content.should include('<meta content="Facebook Share Description" property="og:description" />')
      end
    end

    it 'should display meta tags with hashes and arrays' do
      subject.set_meta_tags(:foo => {
        :bar => "lorem",
        :baz => {
          :qux => ["lorem", "ipsum"]
        },
        :quux => [ {
            :corge => "lorem",
            :grault => "ipsum"
          },
          {
            :corge => "dolor",
            :grault => "sit"
          } ]
      })
      subject.display_meta_tags(:site => 'someSite').tap do |content|
        content.should include('<meta content="lorem" property="foo:bar" />')
        content.should include('<meta content="lorem" property="foo:baz:qux" />')
        content.should include('<meta content="ipsum" property="foo:baz:qux" />')
        content.should include('<meta content="lorem" property="foo:quux:corge"')
        content.should include('<meta content="ipsum" property="foo:quux:grault"')
        content.should include('<meta content="dolor" property="foo:quux:corge"')
        content.should include('<meta content="sit" property="foo:quux:grault"')
        content.should_not include('property="foo:quux"')
      end
    end

    it 'should use deep merge when displaying open graph meta tags' do
      subject.set_meta_tags(:og => { :title => 'Facebook Share Title' })
      subject.display_meta_tags(:og => { :description => 'Facebook Share Description' }).tap do |content|
        content.should include('<meta content="Facebook Share Title" property="og:title" />')
        content.should include('<meta content="Facebook Share Description" property="og:description" />')
      end
    end

    it "should not display meta tags without content" do
      subject.set_meta_tags(:open_graph => {
        :title       => '',
        :description => ''
      })
      subject.display_meta_tags(:site => 'someSite').tap do |content|
        content.should_not include('<meta content="" property="og:title" />')
        content.should_not include('<meta content="" property="og:description" />')
      end
    end
  end

  context 'while handling string meta tag names' do
    it 'should work with common parameters' do
      subject.display_meta_tags('site' => 'someSite', 'title' => 'someTitle').should eq('<title>someSite | someTitle</title>')
    end

    it 'should work with open graph parameters' do
      subject.set_meta_tags('og' => {
        'title'       => 'facebook title',
        'description' => 'facebook description'
      })
      subject.display_meta_tags(:site => 'someSite').tap do |content|
        content.should include('<meta content="facebook title" property="og:title" />')
        content.should include('<meta content="facebook description" property="og:description" />')
      end
    end
  end

  context '.display_title' do
    it 'should display custom title if given' do
      subject.title('someTitle')
      subject.display_title(:site => 'someSite', :title => 'defaultTitle').should eq('someSite | someTitle')
    end
  end

  context 'display any named meta tag that you want to' do
    it 'should display testing meta tag' do
      subject.display_meta_tags(:testing => 'this is a test').should eq('<meta content="this is a test" name="testing" />')
    end

    it 'should support Array values' do
      subject.display_meta_tags(:testing => ['test1', 'test2']).should eq("<meta content=\"test1\" name=\"testing\" />\n<meta content=\"test2\" name=\"testing\" />")
    end

    it 'should not render when value is nil' do
      subject.display_meta_tags(:testing => nil).should eq('')
    end
  end

  it_behaves_like '.set_meta_tags'
end
