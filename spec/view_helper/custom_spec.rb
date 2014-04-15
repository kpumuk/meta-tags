require 'spec_helper'

describe MetaTags::ViewHelper do
  subject { ActionView::Base.new }

  context 'display any named meta tag that you want to' do
    it 'should display testing meta tag' do
      subject.display_meta_tags(:testing => 'this is a test').should eq('<meta content="this is a test" name="testing" />')
    end

    it 'should support Array values' do
      subject.display_meta_tags(:testing => ['test1', 'test2']).should eq("<meta content=\"test1\" name=\"testing\" />\n<meta content=\"test2\" name=\"testing\" />")
    end

    it 'should support Hash values' do
      subject.display_meta_tags(:testing => { :tag => 'value' }).should eq('<meta content="value" name="testing:tag" />')
    end

    it 'should support symbolic references in Hash values' do
      subject.display_meta_tags(:title => 'my title', :testing => { :tag => :title }).should include('<meta content="my title" name="testing:tag" />')
    end

    it 'should not render when value is nil' do
      subject.display_meta_tags(:testing => nil).should eq('')
    end

    it 'should display meta tags with hashes and arrays' do
      subject.set_meta_tags(:foo => {
        :bar => "lorem",
        :baz => {
          :qux => ["lorem", "ipsum"]
        },
        :quux => [
          {
            :corge  => "lorem",
            :grault => "ipsum"
          },
          {
            :corge  => "dolor",
            :grault => "sit"
          }
        ]
      })
      subject.display_meta_tags(:site => 'someSite').tap do |content|
        content.should include('<meta content="lorem" name="foo:bar" />')
        content.should include('<meta content="lorem" name="foo:baz:qux" />')
        content.should include('<meta content="ipsum" name="foo:baz:qux" />')
        content.should include('<meta content="lorem" name="foo:quux:corge"')
        content.should include('<meta content="ipsum" name="foo:quux:grault"')
        content.should include('<meta content="dolor" name="foo:quux:corge"')
        content.should include('<meta content="sit" name="foo:quux:grault"')
        content.should_not include('name="foo:quux"')
      end
    end
  end
end
