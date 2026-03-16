# frozen_string_literal: true

module MetaTags
  # This module contains helpers that normalize text meta tag values.
  module TextNormalizer
    extend self

    # Normalize title value.
    #
    # @param site_title [String] site title.
    # @param title [Array<String>] title segments.
    # @param separator [String] a string to join title parts with.
    # @param reverse [Boolean] whether title should be reversed.
    # @return [String] title with HTML tags removed.
    def normalize_title(site_title, title, separator, reverse = false)
      clean_title = cleanup_strings(title)
      clean_title.reverse! if reverse

      site_title = cleanup_string(site_title)
      separator = cleanup_string(separator, strip: false)

      # Truncate title and site title
      site_title, clean_title = truncate_title(site_title, clean_title, separator)

      if site_title.present?
        if reverse
          clean_title.push(site_title)
        else
          clean_title.unshift(site_title)
        end
      end
      safe_join(clean_title, separator)
    end

    # Normalize description value.
    #
    # @param description [String] description string.
    # @return [String] text with tags removed, squashed spaces, and truncated
    #   to the configured description limit.
    def normalize_description(description)
      # description could be another object not a string, but since it probably
      # serves the same purpose, we can ask it to convert itself to a string
      # and continue from there
      description = cleanup_string(description)
      return "" if description.blank?

      truncate(description, MetaTags.config.description_limit)
    end

    # Normalize keywords value.
    #
    # @param keywords [String, Array<String>] list of keywords as a string or Array.
    # @return [String] list of keywords joined with comma, with tags removed.
    def normalize_keywords(keywords)
      keywords = cleanup_strings(keywords)
      return "" if keywords.blank?

      keywords.each(&:downcase!) if MetaTags.config.keywords_lowercase
      separator = cleanup_string MetaTags.config.keywords_separator, strip: false

      keywords = truncate_array(keywords, MetaTags.config.keywords_limit, separator)
      safe_join(keywords, separator)
    end

    # Easy way to get access to Rails helpers.
    #
    # @return [ActionView::Base] proxy object to access Rails helpers.
    def helpers
      ActionController::Base.helpers
    end

    # Strips all HTML tags from +string+, including comments.
    #
    # @param string [String] HTML string.
    # @return [String] HTML-safe string with no HTML tags.
    def strip_tags(string)
      if defined?(Loofah)
        # Instead of strip_tags we will use Loofah to strip tags from now on
        Loofah.fragment(string).text(encode_special_chars: false)
      else
        helpers.strip_tags(string)
      end
    end

    # This method returns an HTML-safe string similar to what <tt>Array#join</tt>
    # would return. All items in the array, including the supplied separator, are
    # HTML-escaped unless they are HTML-safe, and the returned string is marked
    # as HTML-safe.
    #
    # @param array [Array<String>] list of strings to join.
    # @param sep [String] separator to join strings with.
    # @return [String] input strings joined together using a given separator.
    def safe_join(array, sep = $OFS)
      helpers.safe_join(array, sep)
    end

    # Removes HTML tags and squashes down all the spaces.
    #
    # @param string [String, nil] input string.
    # @param strip [Boolean] whether to trim leading and trailing whitespace.
    # @return [String] input string with no HTML tags and consecutive
    #   whitespace characters squashed into a single space.
    def cleanup_string(string, strip: true)
      return "" if string.nil?
      raise ArgumentError, "Expected a string or an object that implements #to_str" unless string.respond_to?(:to_str)

      s = strip_tags(string.to_str)
      s = s.dup if s.frozen?
      s.gsub!(/\s+/, " ")
      s.strip! if strip

      s
    end

    # Cleans up multiple strings.
    #
    # @param strings [String, Array<String>] input string(s).
    # @param strip [Boolean] whether to trim leading and trailing whitespace.
    # @return [Array<String>] clean strings.
    # @see cleanup_string
    def cleanup_strings(strings, strip: true)
      strings = Array(strings).flatten.map! { |s| cleanup_string(s, strip: strip) }
      strings.reject!(&:blank?)
      strings
    end

    # Truncates a string to a specific limit. Returns the string without
    # truncation when the limit is 0 or nil.
    #
    # @param string [String] input string.
    # @param limit [Integer, nil] number of characters to truncate to.
    # @return [String] truncated string.
    def truncate(string, limit = nil)
      return string if limit.to_i == 0

      helpers.truncate(
        string,
        length: limit,
        separator: MetaTags.config.truncate_on_natural_separator,
        omission: "",
        escape: true
      )
    end

    # Truncates an array of strings to a specific limit.
    #
    # @param string_array [Array<String>] input strings.
    # @param limit [Integer, nil] number of characters to truncate to.
    # @param separator [String] separator that will be used to join the array later.
    # @return [Array<String>] truncated array of strings.
    def truncate_array(string_array, limit = nil, separator = "")
      return string_array if limit.nil? || limit <= 0

      length = 0
      result = [] # : Array[String]

      string_array.each do |string|
        limit_left = calculate_limit_left(limit, length, result, separator)

        if string.length > limit_left
          result << truncate(string, limit_left)
          break string_array
        end

        length += (result.any? ? separator.length : 0) + string.length
        result << string

        # No more strings will fit
        break string_array if length + separator.length >= limit
      end

      result
    end

    private

    # Calculates how many characters are left for the next segment.
    #
    # @param limit [Integer] total truncation limit.
    # @param length [Integer] current accumulated length.
    # @param result [Array<String>] accumulated string segments.
    # @param separator [String] separator inserted between segments.
    # @return [Integer] remaining number of characters.
    def calculate_limit_left(limit, length, result, separator)
      limit - length - (result.any? ? separator.length : 0)
    end

    # Truncates the site title and page title segments to the configured limit.
    #
    # @param site_title [String] site title.
    # @param title [Array<String>] page title segments.
    # @param separator [String] separator used between segments.
    # @return [Array] truncated site title and title segments.
    def truncate_title(site_title, title, separator)
      global_limit = MetaTags.config.title_limit.to_i
      if global_limit > 0
        site_title_limited_length, title_limited_length = calculate_title_limits(
          site_title, title, separator, global_limit
        )

        title = (title_limited_length > 0) ? truncate_array(title, title_limited_length, separator) : [] # : Array[String]
        site_title = (site_title_limited_length > 0) ? truncate(site_title, site_title_limited_length) : nil
      end

      [site_title, title]
    end

    # Calculates the title length limits for the site title and page title.
    #
    # @param site_title [String] site title.
    # @param title [Array<String>] page title segments.
    # @param separator [String] separator used between segments.
    # @param global_limit [Integer] total allowed title length.
    # @return [Array<Integer>] site title limit and page title limit.
    def calculate_title_limits(site_title, title, separator, global_limit)
      # What should we truncate first: site title or page title?
      main_title = MetaTags.config.truncate_site_title_first ? title : [site_title]

      main_length = main_title.map(&:length).sum + ((main_title.size - 1) * separator.length)
      main_limited_length = global_limit

      secondary_limited_length = global_limit - ((main_length > 0) ? main_length + separator.length : 0)
      secondary_limited_length = [0, secondary_limited_length].max

      if MetaTags.config.truncate_site_title_first
        [secondary_limited_length, main_limited_length]
      else
        [main_limited_length, secondary_limited_length]
      end
    end
  end
end
