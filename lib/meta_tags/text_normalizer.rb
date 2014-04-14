module MetaTags
  # Module contains helpers that normalize text meta tag values.
  module TextNormalizer
    # Normalize title value.
    #
    # @param [String, Array<String>] title title string.
    # @return [Array<String>] array of title parts with tags removed.
    #
    def self.normalize_title(title)
      Array(title).flatten.map(&method(:strip_tags))
    end

    # Normalize description value.
    #
    # @param [String] description description string.
    # @return [String] text with tags removed, squashed spaces, truncated
    # to 200 characters.
    #
    def self.normalize_description(description)
      return '' if description.blank?
      helpers.truncate(cleanup_string(description), :length => 200)
    end

    # Normalize keywords value.
    #
    # @param [String, Array<String>] keywords list of keywords as a string or Array.
    # @return [String] list of keywords joined with comma, with tags removed.
    #
    def self.normalize_keywords(keywords)
      return '' if keywords.blank?
      cleanup_strings(keywords).join(', ').downcase
    end

    # Easy way to get access to Rails helpers.
    #
    # @return [ActionView::Base] proxy object to access Rails helpers.
    #
    def self.helpers
      ActionController::Base.helpers
    end

    # Strips all HTML tags from the +html+, including comments.
    #
    # @param [String] string HTML string.
    # @return [String] string with no HTML tags.
    #
    def self.strip_tags(string)
      helpers.strip_tags(string)
    end

    # This method returns a html safe string similar to what <tt>Array#join</tt>
    # would return. All items in the array, including the supplied separator, are
    # html escaped unless they are html safe, and the returned string is marked
    # as html safe.
    #
    # @param [Array<String>] array list of strings to join.
    # @param [String] sep separator to join strings with.
    # @return [String] input strings joined together using a given separator.
    #
    def self.safe_join(array, sep = $,)
      helpers.safe_join(array, sep)
    end

    # Removes HTML tags and squashes down all the spaces.
    #
    # @param [String] string input string.
    # @return [String] input string with no HTML tags and consequent white
    # space characters squashed into a single space.
    #
    def self.cleanup_string(string)
      strip_tags(string).gsub(/\s+/, ' ').strip
    end

    # Cleans multiple strings up.
    #
    # @param [Array<String>] strings input strings.
    # @return [Array<String>] clean strings.
    # @see cleanup_string
    def self.cleanup_strings(strings)
      Array(strings).flatten.map(&method(:cleanup_string))
    end
  end
end
