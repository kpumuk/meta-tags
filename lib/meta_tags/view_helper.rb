require 'ruby-debug'

module MetaTags
  # Contains methods to use in views and helpers.
  #
  module ViewHelper
    # Set meta tags for the page.
    #
    # Method could be used several times, and all options passed will
    # be merged. If you will set the same property several times, last one
    # will take precedence.
    #
    # Usually you will not call this method directly. Use {#title}, {#keywords},
    # {#description} for your daily tasks.
    #
    # @param [Hash] meta_tags list of meta tags. See {#display_meta_tags}
    #   for allowed options.
    #
    # @example
    #   set_meta_tags :title => 'Login Page', :description => 'Here you can login'
    #   set_meta_tags :keywords => 'authorization, login'
    #
    # @see #display_meta_tags
    #
    def set_meta_tags(meta_tags = {})
      @meta_tags ||= {}
      @meta_tags.merge!(meta_tags || {})
    end

    # Set the page title and return it back.
    #
    # This method is best suited for use in helpers. It sets the page title
    # and returns it (or +headline+ if specified).
    #
    # @param [String, Array] title page title. When passed as an
    #   +Array+, parts will be joined divided with configured
    #   separator value (see {#display_meta_tags}).
    # @param [String] headline the value to return from method. Useful
    #   for using this method in views to set both page title
    #   and the content of heading tag.
    # @return [String] returns +title+ value or +headline+ if passed.
    #
    # @example Set HTML title to "Please login", return "Please login"
    #   title 'Login Page'
    # @example Set HTML title to "Login Page", return "Please login"
    #   title 'Login Page', 'Please login'
    # @example Set title as array of strings
    #   title :title => ['part1', 'part2'] # => "part1 | part2"
    #
    # @see #display_meta_tags
    #
    def title(title, headline = '')
      set_meta_tags(:title => title)
      headline.blank? ? title : headline
    end

    # Set the page keywords.
    #
    # @param [String, Array] keywords meta keywords to render in HEAD
    #   section of the HTML document.
    # @return [String, Array] passed value.
    #
    # @example
    #   keywords 'keyword1, keyword2'
    #   keywords %w(keyword1 keyword2)
    #
    # @see #display_meta_tags
    #
    def keywords(keywords)
      set_meta_tags(:keywords => keywords)
      keywords
    end

    # Set the page description.
    #
    # @param [String] page description to be set in HEAD section of
    #   the HTML document. Please note, any HTML tags will be stripped
    #   from output string, and string will be truncated to 200
    #   characters.
    # @return [String] passed value.
    #
    # @example
    #   description 'This is login page'
    #
    # @see #display_meta_tags
    #
    def description(description)
      set_meta_tags(:description => description)
      description
    end

    # Set the noindex meta tag
    #
    # @param [Boolean, String] noindex a noindex value.
    # @return [Boolean, String] passed value.
    #
    # @example
    #   noindex true
    #   noindex 'googlebot'
    #
    # @see #display_meta_tags
    #
    def noindex(noindex)
      set_meta_tags(:noindex => noindex)
      noindex
    end

    # Set the nofollow meta tag
    #
    # @param [Boolean, String] nofollow a nofollow value.
    # @return [Boolean, String] passed value.
    #
    # @example
    #   nofollow true
    #   nofollow 'googlebot'
    #
    # @see #display_meta_tags
    #
    def nofollow(nofollow)
      set_meta_tags(:nofollow => nofollow)
      nofollow
    end

    # Set default meta tag values and display meta tags. This method
    # should be used in layout file.
    #
    # @param [Hash] default default meta tag values.
    # @option default [String] :site (nil) site title;
    # @option default [String] :title ("") page title;
    # @option default [String] :description (nil) page description;
    # @option default [String] :keywords (nil) page keywords;
    # @option default [String, Boolean] :prefix (" ") text between site name and separator; when +false+, no prefix will be rendered;
    # @option default [String] :separator ("|") text used to separate website name from page title;
    # @option default [String, Boolean] :suffix (" ") text between separator and page title; when +false+, no suffix will be rendered;
    # @option default [Boolean] :lowercase (false) when true, the page name will be lowercase;
    # @option default [Boolean] :reverse (false) when true, the page and site names will be reversed;
    # @option default [Boolean, String] :noindex (false) add noindex meta tag; when true, 'robots' will be used, otherwise the string will be used;
    # @option default [Boolean, String] :nofollow (false) add nofollow meta tag; when true, 'robots' will be used, otherwise the string will be used;
    # @option default [String] :canonical (nil) add canonical link tag.
    # @return [String] HTML meta tags to render in HEAD section of the
    #   HTML document.
    #
    # @example
    #   <head>
    #     <%= display_meta_tags :site => 'My website' %>
    #   </head>
    #
    def display_meta_tags(default = {})
      meta_tags = (default || {}).merge(@meta_tags || {})

      # Prefix (leading space)
      prefix = meta_tags.delete :prefix
      prefix = prefix === false ? '' : (prefix || ' ')

      # Separator
      separator = meta_tags.delete :separator
      separator = separator.blank? ? '|' : separator

      # Suffix (trailing space)
      suffix = meta_tags.delete :suffix
      suffix = suffix === false ? '' : (suffix || ' ')

      # Title
      title = meta_tags.delete :title
      if meta_tags.delete(:lowercase) === true and !title.blank?
        title = [*title].map { |t| t.downcase }
      end

      result = []

      # title
      site = meta_tags.delete :site
      if title.blank?
        result << content_tag(:title, site)
      else
        title = normalize_title(title).unshift(site)
        title.reverse! if meta_tags.delete(:reverse) === true
        sep = prefix + separator + suffix
        result << content_tag(:title, title.join(sep))
      end

      # description
      description = normalize_description(meta_tags.delete(:description))
      result << tag(:meta, :name => :description, :content => description) unless description.blank?

      # keywords
      keywords = normalize_keywords(meta_tags.delete(:keywords) )
      result << tag(:meta, :name => :keywords, :content => keywords) unless keywords.blank?

      # noindex & nofollow
      noindex = meta_tags.delete :noindex
      nofollow = meta_tags.delete :nofollow
      noindex_name  = String === noindex  ? noindex  : 'robots'
      nofollow_name = String === nofollow ? nofollow : 'robots'

      if noindex_name == nofollow_name
        content = [noindex && 'noindex', nofollow && 'nofollow'].compact.join(', ')
        result << tag(:meta, :name => noindex_name, :content => content) unless content.blank?
      else
        result << tag(:meta, :name => noindex_name,  :content => 'noindex')  if noindex
        result << tag(:meta, :name => nofollow_name, :content => 'nofollow') if nofollow
      end

      # canonical
      canonical = meta_tags.delete :canonical
      result << tag(:link, :rel => :canonical, :href => canonical) unless canonical.blank?

      # non-standard meta tags ( I'm scowling at you Facebook )
      non_standard = meta_tags.delete(:non_standard)
      non_standard.each do |tags|   
        result << tag(:meta, tags[0][0].to_sym => tags[0][1], tags[1][0].to_sym => tags[1][1])
      end unless non_standard.nil?
      
      # arbitrary meta tags, assumes that anything not specifically labeled should be displayed as a name content pair
      meta_tags.each do |key, value|
        result << tag(:meta, :name => key, :content => value)
      end
      
      result = result.join("\n")
      result.respond_to?(:html_safe) ? result.html_safe : result
    end

    private

      def normalize_title(title)
        [*title].map { |t| h(strip_tags(t)) }
      end

      def normalize_description(description)
        return '' unless description
        truncate(strip_tags(description).gsub(/\s+/, ' '), :length => 200)
      end

      def normalize_keywords(keywords)
        return '' unless keywords
        keywords = keywords.flatten.join(', ') if Array === keywords
        strip_tags(keywords).mb_chars.downcase
      end
  end
end
