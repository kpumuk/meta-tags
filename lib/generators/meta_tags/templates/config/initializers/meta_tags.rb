# frozen_string_literal: true

# Use this setup block to configure all options available in MetaTags.
MetaTags.configure do |config|
  # How many characters should the title meta tag have at most. Default is 70.
  # Set to nil or 0 to remove limits.
  # config.title_limit = 70

  # When true, site title will be truncated instead of title. Default is false.
  # config.truncate_site_title_first = false

  # Add HTML attributes to the <title> HTML tag. Default is {}.
  # config.title_tag_attributes = {}

  # Natural separator when truncating. Default is " " (space character).
  # Set to nil to disable natural separator.
  # This also allows you to use a whitespace regular expression (/\s/) or
  # a Unicode space (/\p{Space}/).
  # config.truncate_on_natural_separator = " "

  # Maximum length of the page description. Default is 300.
  # Set to nil or 0 to remove limits.
  # config.description_limit = 300

  # Maximum length of the keywords meta tag. Default is 255.
  # config.keywords_limit = 255

  # Default separator for keywords meta tag (used when an Array passed with
  # the list of keywords). Default is ", ".
  # config.keywords_separator = ', '

  # When true, keywords will be converted to lowercase, otherwise they will
  # appear on the page as is. Default is true.
  # config.keywords_lowercase = true

  # When true, the output will not include new line characters between meta tags.
  # Default is false.
  # config.minify_output = false

  # When false, generated meta tags will be self-closing (<meta ... />) instead
  # of open (`<meta ...>`). Default is true.
  # config.open_meta_tags = true

  # List of additional meta tags that should use "property" attribute instead
  # of "name" attribute in <meta> tags.
  # config.property_tags.push(
  #   'x-hearthstone:deck',
  # )
end
