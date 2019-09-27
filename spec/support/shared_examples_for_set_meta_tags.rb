# frozen_string_literal: true

shared_examples_for '.set_meta_tags' do
  context 'with a Hash parameter' do
    it 'updates meta tags' do
      subject.set_meta_tags(title: 'hello')
      expect(subject.meta_tags[:title]).to eq('hello')

      subject.set_meta_tags(title: 'world')
      expect(subject.meta_tags[:title]).to eq('world')
    end
  end

  context 'with an Object responding to #to_meta_tags parameter' do
    it 'updates meta tags' do
      object1 = double(to_meta_tags: { title: 'hello' })
      object2 = double(to_meta_tags: { title: 'world' })

      subject.set_meta_tags(object1)
      expect(subject.meta_tags[:title]).to eq('hello')

      subject.set_meta_tags(object2)
      expect(subject.meta_tags[:title]).to eq('world')
    end
  end

  it 'uses deep merge when updating meta tags' do
    subject.set_meta_tags(og: { title: 'hello' })
    expect(subject.meta_tags[:og]).to eq('title' => 'hello')

    subject.set_meta_tags(og: { description: 'world' })
    expect(subject.meta_tags[:og]).to eq('title' => 'hello', 'description' => 'world')

    subject.set_meta_tags(og: { admin: { id: 1 } })
    expect(subject.meta_tags[:og]).to eq('title' => 'hello', 'description' => 'world', 'admin' => { 'id' => 1 })
  end

  it 'normalizes :open_graph to :og' do
    subject.set_meta_tags(open_graph: { title: 'hello' })
    expect(subject.meta_tags[:og]).to eq('title' => 'hello')
  end
end
