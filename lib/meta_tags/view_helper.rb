# frozen_string_literal: true

module MetaTags
  # Contains methods to use in views and helpers.
  module ViewHelper
    # Get meta tags for the page.
    def meta_tags
      @meta_tags ||= MetaTagsCollection.new
    end

    # Set meta tags for the page.
    #
    # This method can be used several times, and all passed options will
    # be merged. If you set the same property several times, the last one
    # will take precedence.
    #
    # Usually you will not call this method directly. Use helpers like
    # {#title}, {#description}, {#noindex}, and {#canonical} for daily tasks.
    # {#keywords} remains available for legacy compatibility.
    #
    # @param meta_tags [Hash] list of meta tags. See {#display_meta_tags}
    #   for allowed options.
    # @see #display_meta_tags
    # @example
    #   set_meta_tags title: 'Login Page', description: 'Here you can login'
    #   set_meta_tags canonical: 'https://example.com/login'
    def set_meta_tags(meta_tags = {})
      self.meta_tags.update(meta_tags)
    end

    # Set the page title and return it.
    #
    # This method is best suited for use in helpers. It sets the page title
    # and returns it (or +headline+ if specified).
    #
    # @param title [nil, String, Array] page title. When passed as an
    #   +Array+, parts will be joined using configured separator value
    #   (see {#display_meta_tags}). When nil, current title will be returned.
    # @param headline [String] the value to return from the method. Useful
    #   for using this method in views to set both page title
    #   and the content of the heading tag.
    # @return [String] returns +title+ value or +headline+ if passed.
    # @see #display_meta_tags
    # @example Set HTML title to "Login Page", return "Login Page"
    #   title 'Login Page'
    # @example Set HTML title to "Login Page", return "Please login"
    #   title 'Login Page', 'Please login'
    # @example Set title as array of strings
    #   title ['part1', 'part2'] # => "part1 | part2"
    # @example Get current title
    #   title
    def title(title = nil, headline = "")
      set_meta_tags(title: title) unless title.nil?
      headline.presence || meta_tags.page_title
    end

    # Set the legacy keywords meta tag.
    #
    # Modern search engines ignore this tag, but some older integrations and
    # internal systems may still read it.
    #
    # @param keywords [String, Array] keywords meta tag value to render in the HEAD
    #   section of the HTML document.
    # @return [String, Array] passed value.
    # @see #display_meta_tags
    # @example
    #   keywords 'keyword1, keyword2'
    #   keywords %w(keyword1 keyword2)
    def keywords(keywords)
      set_meta_tags(keywords: keywords)
      keywords
    end

    # Set the page description.
    #
    # @param description [String] page description to be set in the HEAD section
    #   of the HTML document. Please note that any HTML tags will be stripped
    #   from the output string, and the string will be truncated to the
    #   configured description limit.
    # @return [String] passed value.
    # @see #display_meta_tags
    # @example
    #   description 'This is login page'
    def description(description)
      set_meta_tags(description: description)
      description
    end

    # Set the noindex meta tag.
    #
    # @param noindex [Boolean, String, Array<String>] a noindex value.
    # @return [Boolean, String, Array<String>] passed value.
    # @see #display_meta_tags
    # @example
    #   noindex true
    #   noindex 'googlebot'
    def noindex(noindex = true)
      set_meta_tags(noindex: noindex)
      noindex
    end

    # Set the nofollow meta tag.
    #
    # @param nofollow [Boolean, String, Array<String>] a nofollow value.
    # @return [Boolean, String, Array<String>] passed value.
    # @see #display_meta_tags
    # @example
    #   nofollow true
    #   nofollow 'googlebot'
    def nofollow(nofollow = true)
      set_meta_tags(nofollow: nofollow)
      nofollow
    end

    # Set the refresh meta tag.
    #
    # @param refresh [Integer, String] a refresh value.
    # @return [Integer, String] passed value.
    # @see #display_meta_tags
    # @example
    #   refresh 5
    #   refresh "5;url=http://www.example.com/"
    def refresh(refresh)
      set_meta_tags(refresh: refresh)
      refresh
    end

    # Set default meta tag values and display meta tags. This method
    # should be used in the layout file.
    #
    # @param defaults [Hash] default meta tag values.
    # @option default [String] :site (nil) site title;
    # @option default [String] :title ("") page title;
    # @option default [String] :description (nil) page description;
    # @option default [String] :keywords (nil) legacy page keywords;
    # @option default [String, Boolean] :prefix (" ") text between site name and separator;
    #                                   when +false+, no prefix will be rendered;
    # @option default [String] :separator ("|") text used to separate website name from page title;
    # @option default [String, Boolean] :suffix (" ") text between separator and page title;
    #                                   when +false+, no suffix will be rendered;
    # @option default [Boolean] :lowercase (false) when true, the page title will be lowercase;
    # @option default [Boolean] :reverse (false) when true, the page and site names will be reversed;
    # @option default [Boolean, String] :noindex (false) add noindex meta tag; when true, 'robots' will be used,
    #                                   otherwise the string will be used;
    # @option default [Boolean, String] :nofollow (false) add nofollow meta tag; when true, 'robots' will be used,
    #                                   otherwise the string will be used;
    # @option default [String] :canonical (nil) add canonical link tag.
    # @option default [Hash] :alternate ({}) add alternate link tag.
    # @option default [String] :prev (nil) add legacy prev pagination link tag;
    # @option default [String] :next (nil) add legacy next pagination link tag.
    # @option default [String, Integer] :refresh (nil) meta refresh tag;
    # @option default [Hash] :open_graph ({}) add Open Graph meta tags.
    # @option default [Hash] :open_search ({}) add Open Search link tag.
    # @option default [Hash] :robots ({}) add robots meta tags.
    # @option default [Hash] :googlebot ({}) add googlebot meta tags.
    # @option default [Hash] :bingbot ({}) add bingbot meta tags.
    # @return [String] HTML meta tags to render in HEAD section of the
    #   HTML document.
    # @example Render meta tags in a layout
    #   display_meta_tags site: 'My website'
    # @example ERB layout usage
    #   <<~ERB
    #     <head>
    #       <%= display_meta_tags site: 'My website' %>
    #     </head>
    #   ERB
    def display_meta_tags(defaults = {})
      meta_tags.with_defaults(defaults) { Renderer.new(meta_tags).render(self) }
    end

    # Returns full page title as a string without surrounding <title> tag.
    #
    # The only case when you may need this helper is when you use PJAX. This means
    # that your layout file (with the display_meta_tags helper) will not be rendered,
    # so you have to pass default arguments such as the site title here. You probably
    # want to define a helper with default options to minimize code duplication.
    #
    # @param defaults [Hash] list of meta tags.
    # @option default [String] :site (nil) site title;
    # @option default [String] :title ("") page title;
    # @option default [String, Boolean] :prefix (" ") text between site name and separator; when +false+,
    #                                   no prefix will be rendered;
    # @option default [String] :separator ("|") text used to separate website name from page title;
    # @option default [String, Boolean] :suffix (" ") text between separator and page title; when +false+,
    #                                   no suffix will be rendered;
    # @option default [Boolean] :lowercase (false) when true, the page title will be lowercase;
    # @option default [Boolean] :reverse (false) when true, the page and site names will be reversed;
    # @example Build a PJAX-compatible title string
    #   display_title title: 'My Page', site: 'PJAX Site'
    # @example ERB PJAX container usage
    #   <<~ERB
    #     <div data-page-container="true" title="<%= display_title title: 'My Page', site: 'PJAX Site' %>">
    #     </div>
    #   ERB
    def display_title(defaults = {})
      meta_tags.full_title(defaults)
    end
  end
end
