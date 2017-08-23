module MetaTags
  # MetaTags configuration.
  class Configuration
    # How many characters to truncate title to.
    attr_accessor :title_limit
    # How many characters to truncate description to.
    attr_accessor :description_limit
    # How many characters to truncate keywords to.
    attr_accessor :keywords_limit
    # Keywords separator - a string to join keywords with.
    attr_accessor :keywords_separator
    # Should keywords forced into lowercase?
    attr_accessor :keywords_lowercase

    # Initializes a new instance of Configuration class.
    def initialize
      @title_limit = 70
      @description_limit = 160
      @keywords_limit = 255
      @keywords_separator = ', '
      @keywords_lowercase = true
    end
  end
end
