module MetaTags
  # Contains methods to use in views and helpers.
  #
  module ViewHelper
    # Get meta tags for the page.
    def meta_tags
      @meta_tags ||= {}
    end

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
      self.meta_tags.deep_merge! normalize_open_graph(meta_tags)
    end

    # Set the page title and return it back.
    #
    # This method is best suited for use in helpers. It sets the page title
    # and returns it (or +headline+ if specified).
    #
    # @param [nil, String, Array] title page title. When passed as an
    #   +Array+, parts will be joined divided with configured
    #   separator value (see {#display_meta_tags}). When nil, current
    #   title will be returned.
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
    # @example Get current title
    #   title
    #
    # @see #display_meta_tags
    #
    def title(title = nil, headline = '')
      set_meta_tags(:title => title) unless title.nil?
      headline.blank? ? meta_tags[:title] : headline
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
    # @option default [Hash] :open_graph ({}) add Open Graph meta tags.
    # @return [String] HTML meta tags to render in HEAD section of the
    #   HTML document.
    #
    # @example
    #   <head>
    #     <%= display_meta_tags :site => 'My website' %>
    #   </head>
    #
    def display_meta_tags(default = {})
      meta_tags = normalize_open_graph(default).deep_merge!(self.meta_tags)

      result = []

      # title
      result << content_tag(:title, build_full_title(meta_tags))

      # description
      description = normalize_description(meta_tags[:description])
      result << tag(:meta, :name => :description, :content => description) unless description.blank?

      # keywords
      keywords = normalize_keywords(meta_tags[:keywords])
      result << tag(:meta, :name => :keywords, :content => keywords) unless keywords.blank?

      # noindex & nofollow
      noindex_name  = String === meta_tags[:noindex]  ? meta_tags[:noindex]  : 'robots'
      nofollow_name = String === meta_tags[:nofollow] ? meta_tags[:nofollow] : 'robots'

      if noindex_name == nofollow_name
        content = [meta_tags[:noindex] && 'noindex', meta_tags[:nofollow] && 'nofollow'].compact.join(', ')
        result << tag(:meta, :name => noindex_name, :content => content) unless content.blank?
      else
        result << tag(:meta, :name => noindex_name,  :content => 'noindex')  if meta_tags[:noindex] && meta_tags[:noindex] != false
        result << tag(:meta, :name => nofollow_name, :content => 'nofollow') if meta_tags[:nofollow] && meta_tags[:nofollow] != false
      end

      # Open Graph
      (meta_tags[:open_graph] || {}).each do |property, content|
        result << tag(:meta, :property => "og:#{property}", :content => content) unless content.blank?
      end

      # canonical
      result << tag(:link, :rel => :canonical, :href => meta_tags[:canonical]) unless meta_tags[:canonical].blank?

      result = result.join("\n")
      result.respond_to?(:html_safe) ? result.html_safe : result
    end

    # Returns full page title as a string without surrounding <title> tag.
    #
    # The only case when you may need this helper is when you use pjax. This means
    # that your layour file (with display_meta_tags helper) will not be rendered,
    # so you have to pass default arguments like site title in here. You probably
    # want to define helper with default options to minimize code duplication.
    #
    # @param [Hash] meta_tags list of meta tags.
    # @option default [String] :site (nil) site title;
    # @option default [String] :title ("") page title;
    # @option default [String, Boolean] :prefix (" ") text between site name and separator; when +false+, no prefix will be rendered;
    # @option default [String] :separator ("|") text used to separate website name from page title;
    # @option default [String, Boolean] :suffix (" ") text between separator and page title; when +false+, no suffix will be rendered;
    # @option default [Boolean] :lowercase (false) when true, the page name will be lowercase;
    # @option default [Boolean] :reverse (false) when true, the page and site names will be reversed;
    #
    # @example
    #   <div data-page-container="true" title="<%= display_title :title => 'My Page', :site => 'PJAX Site' %>">
    #
    def display_title(default = {})
      meta_tags = normalize_open_graph(default).deep_merge!(self.meta_tags)
      build_full_title(meta_tags)
    end

    if respond_to? :safe_helper
      safe_helper :display_meta_tags
    end

    private

      def normalize_title(title)
        Array(title).map { |t| h(strip_tags(t)) }
      end

      def normalize_description(description)
        return '' if description.blank?
        truncate(strip_tags(description).gsub(/\s+/, ' '), :length => 200)
      end

      def normalize_keywords(keywords)
        return '' if keywords.blank?
        keywords = keywords.flatten.join(', ') if Array === keywords
        strip_tags(keywords).mb_chars.downcase
      end

      def normalize_open_graph(meta_tags)
        meta_tags ||= {}
        meta_tags[:open_graph] = meta_tags.delete(:og) if meta_tags.key?(:og)
        meta_tags
      end

      def build_full_title(meta_tags)
        # Prefix (leading space)
        prefix = meta_tags[:prefix] === false ? '' : (meta_tags[:prefix] || ' ')

        # Separator
        separator = meta_tags[:separator] === false ? '' : (meta_tags[:separator] || '|')

        # Suffix (trailing space)
        suffix = meta_tags[:suffix] === false ? '' : (meta_tags[:suffix] || ' ')

        # Special case: if separator is hidden, do not display suffix/prefix
        if meta_tags[:separator] == false
          prefix = suffix = ''
        end

        # Title
        title = meta_tags[:title]
        if meta_tags[:lowercase] === true and !title.blank?
          title = Array(title).map { |t| t.downcase }
        end

        # title
        if title.blank?
          meta_tags[:site]
        else
          title = normalize_title(title)
          title.unshift(h(meta_tags[:site])) unless meta_tags[:site].blank?
          title.reverse! if meta_tags[:reverse] === true
          sep = h(prefix) + h(separator) + h(suffix)
          title = title.join(sep)
          # We escaped every chunk of the title, so the whole title should be HTML safe
          title = title.html_safe if title.respond_to?(:html_safe)
          title
        end
      end
  end
end
