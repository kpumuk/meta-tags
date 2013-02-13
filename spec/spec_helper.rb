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
    subject.set_meta_tags(:og => { :title => 'hello' })
    subject.meta_tags[:og].should == { 'title' => 'hello' }

    subject.set_meta_tags(:og => { :description => 'world' })
    subject.meta_tags[:og].should == { 'title' => 'hello', 'description' => 'world' }

    subject.set_meta_tags(:og => { :admin => { :id => 1 } } )
    subject.meta_tags[:og].should == { 'title' => 'hello', 'description' => 'world', 'admin' => { 'id' => 1 } }
  end

  it 'should normalize :open_graph to :og' do
    subject.set_meta_tags(:open_graph => { :title => 'hello' })
    subject.meta_tags[:og].should == { 'title' => 'hello' }
  end
end
