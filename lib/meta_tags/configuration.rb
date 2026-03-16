# frozen_string_literal: true

module MetaTags
  # MetaTags configuration.
  class Configuration
    # How many characters to truncate title to.
    attr_accessor :title_limit

    # HTML attributes for the title tag.
    attr_accessor :title_tag_attributes

    # Truncate site_title instead of title.
    attr_accessor :truncate_site_title_first

    # A string or regexp separator to truncate text at a natural break.
    attr_accessor :truncate_on_natural_separator

    # When true, multi-item arrays stop at item boundaries instead of
    # truncating the overflowing item.
    attr_accessor :truncate_array_items_at_boundaries

    # How many characters to truncate description to.
    attr_accessor :description_limit

    # How many characters to truncate keywords to.
    attr_accessor :keywords_limit

    # Keywords separator - a string to join keywords with.
    attr_accessor :keywords_separator

    # Should keywords be forced into lowercase?
    attr_accessor :keywords_lowercase

    # Switches between open (<meta ... >) and closed (<meta ... />) meta tags.
    # Default is true, which means "open".
    attr_accessor :open_meta_tags

    # When true, the output will not include new line characters between meta tags.
    # Default is false.
    attr_accessor :minify_output

    # Custom meta tags that should use the `property` attribute instead of `name`.
    # An array of strings or symbols representing their names or name prefixes.
    attr_reader :property_tags

    # Configure whether MetaTags should skip canonical links on pages with
    # `noindex: true`.
    # John Mueller has noted that mixing `noindex` and `rel=canonical` sends
    # contradictory signals.
    # https://www.reddit.com/r/TechSEO/comments/8yahdr/2_questions_about_the_canonical_tag/e2dey9i/
    attr_accessor :skip_canonical_links_on_noindex

    # Initializes a new instance of Configuration class.
    def initialize
      reset_defaults!
    end

    # Returns the default meta tag prefixes and names that use `property`.
    #
    # @return [Array<String>] default property tag names.
    def default_property_tags
      [
        # App Links metadata https://developers.facebook.com/docs/applinks/metadata-reference
        "al",
        # Open Graph Markup https://developers.facebook.com/docs/sharing/webmasters#markup
        "fb",
        "og",
        # Facebook Open Graph object types https://developers.facebook.com/docs/reference/opengraph
        # These tags are matched as exact property names or namespace prefixes, so e.g.
        # 'restaurant' affects 'restaurant:category', 'restaurant:price_rating', and other
        # properties under that namespace.
        "article",
        "book",
        "books",
        "business",
        "fitness",
        "game",
        "music",
        "place",
        "product",
        "profile",
        "restaurant",
        "video"
      ].freeze
    end

    # Indicates whether meta tags should be rendered with open tag syntax.
    #
    # @return [Boolean] true when open meta tags are enabled.
    def open_meta_tags?
      !!open_meta_tags
    end

    # Restores the default configuration values.
    #
    # @return [void]
    def reset_defaults!
      @title_limit = 70
      @truncate_site_title_first = false
      @truncate_on_natural_separator = " "
      @truncate_array_items_at_boundaries = false
      @title_tag_attributes = {}
      @description_limit = 300
      @keywords_limit = 255
      @keywords_separator = ", "
      @keywords_lowercase = true
      @property_tags = default_property_tags.dup
      @open_meta_tags = true
      @minify_output = false
      @skip_canonical_links_on_noindex = false
    end
  end
end
