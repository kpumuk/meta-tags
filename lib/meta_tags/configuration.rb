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
        'product:age_group',
        'product:availability',
        'product:brand',
        'product:category',
        'product:color',
        'product:condition',
        'product:ean',
        'product:expiration_time',
        'product:is_product_shareable',
        'product:isbn',
        'product:material',
        'product:mfr_part_no',
        'product:original_price',
        'product:original_price:amount',
        'product:original_price:currency',
        'product:pattern',
        'product:plural_title',
        'product:pretax_price',
        'product:pretax_price:amount',
        'product:pretax_price:currency',
        'product:price',
        'product:price:amount',
        'product:price:currency',
        'product:product_link',
        'product:purchase_limit',
        'product:retailer',
        'product:retailer_category',
        'product:retailer_part_no',
        'product:retailer_title',
        'product:sale_price',
        'product:sale_price:amount',
        'product:sale_price:currency',
        'product:sale_price_dates',
        'product:sale_price_dates:start',
        'product:sale_price_dates:end',
        'product:shipping_cost',
        'product:shipping_cost:amount',
        'product:shipping_cost:currency',
        'product:shipping_weight',
        'product:shipping_weight:value',
        'product:shipping_weight:units',
        'product:size',
        'product:target_gender',
        'product:upc',
        'product:weight',
        'product:weight:value',
        'product:weight:units',
        'profile',
        'profile:first_name',
        'profile:gender',
        'profile:last_name',
        'profile:username',
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
      @description_limit = 160
      @keywords_limit = 255
      @keywords_separator = ', '
      @keywords_lowercase = true
      @property_tags = default_property_tags.dup
    end
  end
end
