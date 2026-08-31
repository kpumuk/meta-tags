# frozen_string_literal: true

require "spec_helper"

RSpec.describe MetaTags::ViewHelper do
  describe "display any named meta tag that you want to" do
    before { allow(MetaTags.deprecator).to receive(:warn) }

    it "displays testing meta tag" do
      subject.display_meta_tags(testing: "this is a test").tap do |meta|
        expect(meta).to have_tag("meta", with: {content: "this is a test", name: "testing"})
      end
    end

    it "supports Array values" do
      subject.display_meta_tags(testing: ["test1", "test2"]).tap do |meta|
        expect(meta).to have_tag("meta", with: {content: "test1", name: "testing"})
        expect(meta).to have_tag("meta", with: {content: "test2", name: "testing"})
      end
    end

    it "supports Hash values" do
      subject.display_meta_tags(testing: {tag: "value"}).tap do |meta|
        expect(meta).to have_tag("meta", with: {content: "value", name: "testing:tag"})
      end
    end

    it "resolves symbolic references in Hash values" do
      meta = subject.display_meta_tags(title: "my title", testing: {tag: :title})

      expect(meta).to eq(<<~HTML.chomp)
        <title>my title</title>
        <meta name="testing:tag" content="my title">
      HTML
      expect(MetaTags.deprecator).not_to have_received(:warn)
    end

    it "warns about Symbol values in Array values without changing their output" do
      meta = subject.display_meta_tags(
        image_src: "https://example.com/image.png",
        og: {image: [:image_src]}
      )

      expect(meta).to eq(<<~HTML.chomp)
        <link rel="image_src" href="https://example.com/image.png">
        <meta property="og:image" content="image_src">
      HTML
      expect(MetaTags.deprecator).to have_received(:warn).once.with(
        include(
          ":image_src",
          "rendered literally in MetaTags 2.x",
          "MetaTags.config.resolve_symbolic_references_in_arrays = true",
          "default in MetaTags 3.0"
        )
      )
    end

    it "resolves symbolic references in Array values when configured" do
      MetaTags.config.resolve_symbolic_references_in_arrays = true

      meta = subject.display_meta_tags(
        description: "Image description",
        image_src: "https://example.com/image.png",
        og: {
          image: [:image_src, {alt: [:description]}],
          video: [:missing],
          audio: :image_src
        }
      )

      expect(meta).to eq(<<~HTML.chomp)
        <meta name="description" content="Image description">
        <link rel="image_src" href="https://example.com/image.png">
        <meta property="og:image" content="https://example.com/image.png">
        <meta property="og:image:alt" content="Image description">
        <meta property="og:audio" content="https://example.com/image.png">
      HTML
      expect(MetaTags.deprecator).not_to have_received(:warn)
    end

    it "resolves existing Hash references only once when Array references are configured" do
      MetaTags.config.resolve_symbolic_references_in_arrays = true

      meta = subject.display_meta_tags(
        image_src: :asset,
        og: {image: {alt: :image_src}}
      )

      expect(meta).to eq(<<~HTML.chomp)
        <link rel="image_src" href="asset">
        <meta property="og:image:alt" content="asset">
      HTML
      expect(MetaTags.deprecator).not_to have_received(:warn)
    end

    it "warns about literal Symbol values in Array values" do
      meta = subject.display_meta_tags(article: {tag: [:ruby, :rails]})

      expect(meta).to eq(<<~HTML.chomp)
        <meta property="article:tag" content="ruby">
        <meta property="article:tag" content="rails">
      HTML
      expect(MetaTags.deprecator).to have_received(:warn).once.with(include(":ruby"))
    end

    it "does not warn about top-level Symbol Array values" do
      meta = subject.display_meta_tags(title: "my title", testing: [:title])

      expect(meta).to eq(<<~HTML.chomp)
        <title>my title</title>
        <meta name="testing" content="title">
      HTML
      expect(MetaTags.deprecator).not_to have_received(:warn)
    end

    it "warns about Symbol values in nested Array values" do
      meta = subject.display_meta_tags(
        description: "Image description",
        image_src: "https://example.com/image.png",
        og: {image: [{_: :image_src, alt: [:description]}]}
      )

      expect(meta).to eq(<<~HTML.chomp)
        <meta name="description" content="Image description">
        <link rel="image_src" href="https://example.com/image.png">
        <meta property="og:image" content="https://example.com/image.png">
        <meta property="og:image:alt" content="description">
      HTML
      expect(MetaTags.deprecator).to have_received(:warn).once.with(
        include(":description", "rendered literally in MetaTags 2.x", "mirrored reference in MetaTags 3.0")
      )
    end

    it "warns about missing symbolic references only when nested directly in Arrays" do
      meta = subject.display_meta_tags(
        og: {
          image: :missing,
          video: [:missing],
          audio: [{_: :missing}]
        }
      )

      expect(meta).to eq('<meta property="og:video" content="missing">')
      expect(MetaTags.deprecator).to have_received(:warn).once.with(include(":missing"))
    end

    it "does not render when value is nil" do
      subject.display_meta_tags(testing: nil).tap do |meta|
        expect(meta).to eq("")
      end
    end

    it "allows to specify itemprop" do
      subject.set_meta_tags(
        og: {
          image: {
            _: "image.png",
            type: "image/jpeg",
            width: 200,
            height: {
              _: 200,
              itemprop: "custom"
            },
            itemprop: "image"
          }
        }
      )

      meta = subject.display_meta_tags
      aggregate_failures "meta tags" do
        expect(meta).to have_tag("meta", with: {property: "og:image", content: "image.png", itemprop: "image"})
        expect(meta).to have_tag("meta", with: {property: "og:image:type", content: "image/jpeg"}, without: {itemprop: "image"})
        expect(meta).to have_tag("meta", with: {property: "og:image:width", content: "200"}, without: {itemprop: "image"})
        expect(meta).to have_tag("meta", with: {property: "og:image:height", content: "200", itemprop: "custom"})
        expect(meta).not_to have_tag("meta", with: {property: "og:image:itemprop"})
      end
    end

    it "preserves itemprop and collection state across renders" do
      subject.set_meta_tags(og: {image: {_: "image.png", itemprop: "image"}})
      original_meta_tags = subject.meta_tags.meta_tags.deep_dup

      first_render = subject.display_meta_tags
      second_render = subject.display_meta_tags

      expect(first_render).to eq('<meta property="og:image" content="image.png" itemprop="image">')
      expect(second_render).to eq(first_render)
      expect(subject.meta_tags.meta_tags).to eq(original_meta_tags)
    end

    it "inherits itemprop through anonymous containers only" do
      meta = subject.display_meta_tags(
        twitter: {
          image: {
            _: [
              "direct.png",
              {_: "wrapped.png"},
              {_: "overridden.png", itemprop: "custom"},
              {alt: {_: "description"}}
            ],
            itemprop: "image"
          }
        }
      )

      expect(meta).to eq(<<~HTML.chomp)
        <meta name="twitter:image" content="direct.png" itemprop="image">
        <meta name="twitter:image" content="wrapped.png" itemprop="image">
        <meta name="twitter:image" content="overridden.png" itemprop="custom">
        <meta name="twitter:image:alt" content="description">
      HTML
    end

    it "displays meta tags with hashes and arrays" do
      test_hashes_and_arrays
    end

    it "uses `property` attribute instead of `name` for custom tags listed under `property_tags` in config" do
      MetaTags.config.property_tags.push(:testing1, "testing2", "namespace:")

      subject.display_meta_tags("testing1" => "test").tap do |meta|
        expect(meta).to have_tag("meta", with: {content: "test", property: "testing1"})
      end

      subject.display_meta_tags("testing2:nested" => "nested test").tap do |meta|
        expect(meta).to have_tag("meta", with: {content: "nested test", property: "testing2:nested"})
      end

      subject.display_meta_tags("namespace:thing" => "namespace test").tap do |meta|
        expect(meta).to have_tag("meta", with: {content: "namespace test", property: "namespace:thing"})
      end
    end

    it "displays `property_tags` in hashes and arrays properly" do
      MetaTags.config.property_tags.push(:foo)

      test_hashes_and_arrays(name_key: :property)
    end

    it "does not use `property` tag for the keys that do not match `property_tags`" do
      MetaTags.config.property_tags.push(:foos)
      MetaTags.config.property_tags.push(:fo)

      test_hashes_and_arrays(name_key: :name)
    end

    it "matches configured property tags only by exact name or colon-delimited namespace" do
      MetaTags.config.property_tags.push(:testing)

      subject.display_meta_tags("testing" => "exact match").tap do |meta|
        expect(meta).to have_tag("meta", with: {content: "exact match", property: "testing"})
      end

      subject.display_meta_tags("testing:nested" => "namespace match").tap do |meta|
        expect(meta).to have_tag("meta", with: {content: "namespace match", property: "testing:nested"})
      end

      subject.display_meta_tags("testing-other" => "hyphen mismatch").tap do |meta|
        expect(meta).to have_tag("meta", with: {content: "hyphen mismatch", name: "testing-other"})
        expect(meta).not_to have_tag("meta", with: {content: "hyphen mismatch", property: "testing-other"})
      end
    end
  end

  def test_hashes_and_arrays(name_key: :name)
    subject.set_meta_tags(
      foo: {
        _: "test",
        bar: "lorem",
        baz: {
          qux: ["lorem", "ipsum"]
        },
        quux: [
          {
            corge: "lorem",
            grault: "ipsum"
          },
          {
            corge: "dolor",
            grault: "sit"
          }
        ]
      }
    )
    subject.display_meta_tags(site: "someSite").tap do |meta|
      expect(meta).to have_tag("meta", with: {:content => "lorem", name_key => "foo:bar"})
      expect(meta).to have_tag("meta", with: {:content => "lorem", name_key => "foo:baz:qux"})
      expect(meta).to have_tag("meta", with: {:content => "ipsum", name_key => "foo:baz:qux"})
      expect(meta).to have_tag("meta", with: {:content => "lorem", name_key => "foo:quux:corge"})
      expect(meta).to have_tag("meta", with: {:content => "ipsum", name_key => "foo:quux:grault"})
      expect(meta).to have_tag("meta", with: {:content => "dolor", name_key => "foo:quux:corge"})
      expect(meta).to have_tag("meta", with: {:content => "sit", name_key => "foo:quux:grault"})
      expect(meta).not_to have_tag("meta", with: {name: "foo:quux"})
    end
  end
end
