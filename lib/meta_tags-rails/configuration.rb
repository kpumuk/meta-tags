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

    # Initializes a new instance of Configuration class.
    def initialize
      @title_limit = 70
      @description_limit = 160
      @keywords_limit = 255
      @keywords_separator = ', '
    end
  end
end
