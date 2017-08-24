# Use this setup block to configure all options available in MetaTags.
MetaTags.configure do |config|
  # How many characters should the title meta tag have at most. Default is 70.
  # config.title_limit = 70

  # Maximum length of the page description. Default is 160.
  # config.description_limit = 160

  # Maxumum length of the keywords meta tag. Default is 255.
  # config.keywords_limit = 255

  # Default separator for keywords meta tag (used when an Array passed with
  # the list of keywords). Default is ", ".
  # config.keywords_separator = ', '

  # When true, keywords will be converted to lowercase, otherwise they will
  # appear on the page as is. Default is true.
  # config.keywords_lowercase = true

  # List of additional meta tags that should use "property" attribute instead
  # of "name" attribute in <meta> tags.
  # config.property_tags.push(
  #   'x-hearthstone:deck',
  # )
end
