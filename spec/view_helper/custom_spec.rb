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
      test_hashes_and_arrays
    end

    it 'should use `property` attribute instead of `name` for custom tags listed under `custom_property_tags` in config' do
      MetaTags.configure do |config|
        config.custom_property_tags = [:testing1, 'testing2']
      end

      subject.display_meta_tags('testing1': 'test').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "test", property: "testing1" })
      end

      subject.display_meta_tags('testing2:nested': 'nested test').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "nested test", property: "testing2:nested" })
      end
    end

    it 'should display `custom_property_tags` in hashes and arrays properly' do
      MetaTags.configure do |config|
        config.custom_property_tags = [:foo]
      end

      test_hashes_and_arrays(name_key: :property)
    end
  end

  def test_hashes_and_arrays(name_key: :name)
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
      expect(meta).to have_tag('meta', with: { content: "lorem", name_key => "foo:bar" })
      expect(meta).to have_tag('meta', with: { content: "lorem", name_key => "foo:baz:qux" })
      expect(meta).to have_tag('meta', with: { content: "ipsum", name_key => "foo:baz:qux" })
      expect(meta).to have_tag('meta', with: { content: "lorem", name_key => "foo:quux:corge" })
      expect(meta).to have_tag('meta', with: { content: "ipsum", name_key => "foo:quux:grault" })
      expect(meta).to have_tag('meta', with: { content: "dolor", name_key => "foo:quux:corge" })
      expect(meta).to have_tag('meta', with: { content: "sit", name_key => "foo:quux:grault" })
      expect(meta).to_not have_tag('meta', with: { name: "foo:quux" })
    end
  end
end
