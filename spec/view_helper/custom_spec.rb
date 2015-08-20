require 'spec_helper'

describe MetaTags::ViewHelper do
  subject { ActionView::Base.new }

  context 'display any named meta tag that you want to' do
    it 'should display testing meta tag' do
      subject.display_meta_tags(testing: 'this is a test').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "this is a test", name: "testing" })
      end
    end

    it 'should support Array values' do
      subject.display_meta_tags(testing: ['test1', 'test2']).tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "test1", name: "testing" })
        expect(meta).to have_tag('meta', with: { content: "test2", name: "testing" })
      end
    end

    it 'should support Hash values' do
      subject.display_meta_tags(testing: { tag: 'value' }).tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "value", name: "testing:tag" })
      end
    end

    it 'should support symbolic references in Hash values' do
      subject.display_meta_tags(title: 'my title', testing: { tag: :title }).tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "my title", name: "testing:tag" })
      end
    end

    it 'should not render when value is nil' do
      subject.display_meta_tags(testing: nil).tap do |meta|
        expect(meta).to eq('')
      end
    end

    it 'should display meta tags with hashes and arrays' do
      subject.set_meta_tags(foo: {
        bar: "lorem",
        baz: {
          qux: ["lorem", "ipsum"]
        },
        quux: [
          {
            corge:  "lorem",
            grault: "ipsum"
          },
          {
            corge:  "dolor",
            grault: "sit"
          }
        ]
      })
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "lorem", name: "foo:bar" })
        expect(meta).to have_tag('meta', with: { content: "lorem", name: "foo:baz:qux" })
        expect(meta).to have_tag('meta', with: { content: "ipsum", name: "foo:baz:qux" })
        expect(meta).to have_tag('meta', with: { content: "lorem", name: "foo:quux:corge" })
        expect(meta).to have_tag('meta', with: { content: "ipsum", name: "foo:quux:grault" })
        expect(meta).to have_tag('meta', with: { content: "dolor", name: "foo:quux:corge" })
        expect(meta).to have_tag('meta', with: { content: "sit", name: "foo:quux:grault" })
        expect(meta).to_not have_tag('meta', with: { name: "foo:quux" })
      end
    end
  end
end
