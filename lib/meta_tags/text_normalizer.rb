module MetaTags
  # Module contains helpers that normalize text meta tag values.
  module TextNormalizer
    extend self # rubocop:disable Style/ModuleFunction

    # Normalize title value.
    #
    # @param [String] site_title site title.
    # @param [String, Array<String>] title title string.
    # @param [String] separator a string to join title parts with.
    # @param [true,false] reverse whether title should be reversed.
    # @return [Array<String>] array of title parts with tags removed.
    #
    def normalize_title(site_title, title, separator, reverse = false)
      title = Array(title).flatten.map(&method(:strip_tags)).reject(&:blank?)
      title.reverse! if reverse

      site_title = strip_tags(site_title)
      separator = strip_tags(separator)

      # Truncate title and site title
      site_title, title = truncate_title(site_title, title, separator)

      if site_title.present?
        if reverse
          title.push(site_title)
        else
          title.unshift(site_title)
        end
      end
      safe_join(title, separator)
    end

    # Normalize description value.
    #
    # @param [String] description description string.
    # @return [String] text with tags removed, squashed spaces, truncated
    # to 200 characters.
    #
    def normalize_description(description)
      return '' if description.blank?
      description = cleanup_string(description)
      truncate(description, MetaTags.config.description_limit)
    end

    # Normalize keywords value.
    #
    # @param [String, Array<String>] keywords list of keywords as a string or Array.
    # @return [String] list of keywords joined with comma, with tags removed.
    #
    def normalize_keywords(keywords)
      return '' if keywords.blank?
      keywords = cleanup_strings(keywords)
      keywords.each(&:downcase!) if MetaTags.config.keywords_lowercase
      separator = strip_tags MetaTags.config.keywords_separator

      keywords = truncate_array(keywords, MetaTags.config.keywords_limit, separator)
      safe_join(keywords, separator)
    end

    # Easy way to get access to Rails helpers.
    #
    # @return [ActionView::Base] proxy object to access Rails helpers.
    #
    def helpers
      ActionController::Base.helpers
    end

    # Strips all HTML tags from the +html+, including comments.
    #
    # @param [String] string HTML string.
    # @return [String] html_safe string with no HTML tags.
    #
    def strip_tags(string)
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
    def safe_join(array, sep = $OFS)
      helpers.safe_join(array, sep)
    end

    # Removes HTML tags and squashes down all the spaces.
    #
    # @param [String] string input string.
    # @return [String] input string with no HTML tags and consequent white
    # space characters squashed into a single space.
    #
    def cleanup_string(string)
      strip_tags(string).gsub(/\s+/, ' ').strip
    end

    # Cleans multiple strings up.
    #
    # @param [Array<String>] strings input strings.
    # @return [Array<String>] clean strings.
    # @see cleanup_string
    #
    def cleanup_strings(strings)
      Array(strings).flatten.map(&method(:cleanup_string))
    end

    # Truncates a string to a specific limit. Return string without truncation when limit 0 or nil
    #
    # @param [String] string input strings.
    # @param [Integer,nil] limit characters number to truncate to.
    # @param [String] natural_separator natural separator to truncate at.
    # @return [String] truncated string.
    #
    def truncate(string, limit = nil, natural_separator = ' ')
      return string if limit.to_i == 0

      helpers.truncate(
        string,
        length:    limit,
        separator: natural_separator,
        omission:  '',
        escape:    false,
      )
    end

    # Truncates a string to a specific limit.
    #
    # @param [Array<String>] string_array input strings.
    # @param [Integer,nil] limit characters number to truncate to.
    # @param [String] separator separator that will be used to join array later.
    # @param [String] natural_separator natural separator to truncate at.
    # @return [String] truncated string.
    #
    def truncate_array(string_array, limit = nil, separator = '', natural_separator = ' ')
      return string_array if limit.nil? || limit <= 0

      length = 0
      result = []

      string_array.each do |string|
        limit_left = calculate_limit_left(limit, length, result, separator)

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

    private

    def calculate_limit_left(limit, length, result, separator)
      limit - length - (result.any? ? separator.length : 0)
    end

    def truncate_title(site_title, title, separator)
      if MetaTags.config.title_limit.to_i > 0
        site_title_limited_length, title_limited_length = calculate_title_limits(site_title, title, separator)

        title = title_limited_length > 0 ? truncate_array(title, title_limited_length, separator) : []
        site_title = site_title_limited_length > 0 ? truncate(site_title, site_title_limited_length) : nil
      end

      [site_title, title]
    end

    def calculate_title_limits(site_title, title, separator)
      # What should we truncate first: site title or page title?
      main_title = MetaTags.config.truncate_site_title_first ? title : [site_title]

      main_length = main_title.map(&:length).sum + (main_title.size - 1) * separator.length
      main_limited_length = MetaTags.config.title_limit

      secondary_limited_length = MetaTags.config.title_limit - (main_length > 0 ? main_length + separator.length : 0)
      secondary_limited_length = [0, secondary_limited_length].max

      if MetaTags.config.truncate_site_title_first
        [ secondary_limited_length, main_limited_length ]
      else
        [ main_limited_length, secondary_limited_length ]
      end
    end
  end
end
