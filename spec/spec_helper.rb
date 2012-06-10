require 'bundler/setup'
require 'meta_tags'

shared_examples_for '.set_meta_tags' do
  it 'should update meta tags' do
    subject.set_meta_tags(:title => 'hello')
    subject.meta_tags[:title].should == 'hello'

    subject.set_meta_tags(:title => 'world')
    subject.meta_tags[:title].should == 'world'
  end

  it 'should use deep merge when updating meta tags' do
    subject.set_meta_tags(:open_graph => { :title => 'hello' })
    subject.meta_tags[:open_graph].should == { :title => 'hello' }

    subject.set_meta_tags(:open_graph => { :description => 'world' })
    subject.meta_tags[:open_graph].should == { :title => 'hello', :description => 'world' }
  end

  it 'should normalize :og to :open_graph' do
    subject.set_meta_tags(:og => { :title => 'hello' })
    subject.meta_tags[:open_graph].should == { :title => 'hello' }
  end
end
