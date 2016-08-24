module MetaTags
  # Module contains helpers that normalize text meta tag values.
  module TextNormalizer
    # Normalize title value.
    #
    # @param [String] site_title site title.
    # @param [String, Array<String>] title title string.
    # @param [String] separator a string to join title parts with.
    # @param [true,false] reverse whether title should be reversed.
    # @return [Array<String>] array of title parts with tags removed.
    #
    def self.normalize_title(site_title, title, separator, reverse = false)
      title = Array(title).flatten.map(&method(:strip_tags))
      title.reject!(&:blank?)
      site_title = strip_tags(site_title)
      separator = strip_tags(separator)

      if MetaTags.config.title_limit
        limit = if site_title.present?
          MetaTags.config.title_limit - separator.length
        else
          # separtor won't be used: ignore its length
          MetaTags.config.title_limit
        end

        if limit > site_title.length
          title = truncate_array(title, limit - site_title.length, separator)
        else
          site_title = truncate(site_title, limit)
          # Site title is too long, we have to skip page title
          title = []
        end
      end

      title.unshift(site_title) if site_title.present?
      title.reverse! if reverse
      safe_join(title, separator)
    end

    # Normalize description value.
    #
    # @param [String] description description string.
    # @return [String] text with tags removed, squashed spaces, truncated
    # to 200 characters.
    #
    def self.normalize_description(description)
      return '' if description.blank?
      description = cleanup_string(description)
      truncate(description, MetaTags.config.description_limit)
    end

    # Normalize keywords value.
    #
    # @param [String, Array<String>] keywords list of keywords as a string or Array.
    # @return [String] list of keywords joined with comma, with tags removed.
    #
    def self.normalize_keywords(keywords)
      return '' if keywords.blank?
      keywords = cleanup_strings(keywords).each(&:downcase!)
      separator = strip_tags MetaTags.config.keywords_separator

      keywords = truncate_array(keywords, MetaTags.config.keywords_limit, separator)
      safe_join(keywords, separator)
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
    # @return [String] html_safe string with no HTML tags.
    #
    def self.strip_tags(string)
      if defined?(Loofah)
        # Instead of strip_tags we will use Loofah to strip tags from now on
        stripped_unescaped = Loofah.fragment(string).text(encode_special_chars: false)
        ERB::Util.html_escape stripped_unescaped
      else
        ERB::Util.html_escape helpers.strip_tags(string)
      end
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
      strip_tags(string).gsub(/\s+/, ' ').strip.html_safe
    end

    # Cleans multiple strings up.
    #
    # @param [Array<String>] strings input strings.
    # @return [Array<String>] clean strings.
    # @see cleanup_string
    #
    def self.cleanup_strings(strings)
      Array(strings).flatten.map(&method(:cleanup_string))
    end

    # Truncates a string to a specific limit.
    #
    # @param [String] string input strings.
    # @param [Integer,nil] limit characters number to truncate to.
    # @param [String] natural_separator natural separator to truncate at.
    # @return [String] truncated string.
    #
    def self.truncate(string, limit = nil, natural_separator = ' ')
      string = helpers.truncate(string, length: limit, separator: natural_separator, omission: '', escape: false) if limit
      string.html_safe
    end

    # Truncates a string to a specific limit.
    #
    # @param [Array<String>] string_array input strings.
    # @param [Integer,nil] limit characters number to truncate to.
    # @param [String] separator separator that will be used to join array later.
    # @param [String] natural_separator natural separator to truncate at.
    # @return [String] truncated string.
    #
    def self.truncate_array(string_array, limit = nil, separator = '', natural_separator = ' ')
      return string_array if limit.nil? || limit == 0
      length = 0
      result = []
      string_array.each do |string|
        limit_left = limit - length - (result.any? ? separator.length : 0)
        if string.length > limit_left
          result << truncate(string, limit_left, natural_separator)
          break
        end
        length += (result.any? ? separator.length : 0) + string.length
        result << string
        # No more strings will fit
        break if length + separator.length >= limit
      end
      result
    end
  end
end
