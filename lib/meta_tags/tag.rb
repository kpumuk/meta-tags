# frozen_string_literal: true

module MetaTags
  # Represents an HTML meta tag with no content (<tag />).
  class Tag
    attr_reader :name, :attributes

    # Initializes a new instance of Tag class.
    #
    # @param name [String, Symbol] HTML tag name.
    # @param attributes [Hash] list of HTML tag attributes.
    def initialize(name, attributes = {})
      @name = name.to_s
      @attributes = attributes
    end

    # Renders the tag in a Rails view.
    #
    # @param view [ActionView::Base] instance of a Rails view.
    # @return [String] HTML string for the tag.
    def render(view)
      view.tag(name, serialize_iso8601_attributes(attributes), MetaTags.config.open_meta_tags?)
    end

    protected

    # Serializes attribute values that support ISO 8601 formatting.
    #
    # @param attributes [Hash] HTML tag attributes.
    # @return [Hash] normalized HTML tag attributes.
    def serialize_iso8601_attributes(attributes)
      attributes.each do |key, value|
        attributes[key] = value.iso8601 if value.respond_to?(:iso8601)
      end
    end
  end
end
