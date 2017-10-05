module MetaTags
  # MetaTags configuration.
  class Configuration
    # How many characters to truncate title to.
    attr_accessor :title_limit

    # Truncate site_title instead of title.
    attr_accessor :truncate_site_title_first

    # How many characters to truncate description to.
    attr_accessor :description_limit

    # How many characters to truncate keywords to.
    attr_accessor :keywords_limit

    # Keywords separator - a string to join keywords with.
    attr_accessor :keywords_separator

    # Should keywords forced into lowercase?
    attr_accessor :keywords_lowercase

    # Custom meta tags that should use `property` attribute instead of `name`
    # - an array of strings or symbols representing their names or name-prefixes.
    attr_reader :property_tags

    # Initializes a new instance of Configuration class.
    def initialize
      reset_defaults!
    end

    def default_property_tags
      [
        # App Link metadata https://developers.facebook.com/docs/applinks/metadata-reference
        'al',
        # Open Graph Markup https://developers.facebook.com/docs/sharing/webmasters#markup
        'fb',
        'og',
        # Facebook OpenGraph Object Types https://developers.facebook.com/docs/reference/opengraph
        'article',
        'book',
        'books:author',
        'books:book',
        'books:genre',
        'business:business',
        'fitness:course',
        'game:achievement',
        'music:album',
        'music:playlist',
        'music:radio_station',
        'music:song',
        'place',
        'product',
        'product:group',
        'product:item',
        'profile',
        'restaurant:menu',
        'restaurant:menu_item',
        'restaurant:menu_section',
        'restaurant:restaurant',
        'video:episode',
        'video:movie',
        'video:other',
        'video:tv_show',
      ].freeze
    end

    def reset_defaults!
      @title_limit = 70
      @truncate_site_title_first = false
      @keywords_limit = 255
      @keywords_separator = ', '
      @keywords_lowercase = true
      @property_tags = default_property_tags.dup
    end
  end
end
