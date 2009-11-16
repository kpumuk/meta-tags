# Contains methods to use in views and helpers.
module MetaTags
  module ViewHelper
    # Set meta tags for the page.
    #
    # Method could be used several times, and all options passed will
    # be merged. If you will set the same property several times, last one
    # will take precedence.
    #
    # Examples:
    #   set_meta_tags :title => 'Login Page', :description => 'Here you can login'
    #   set_meta_tags :keywords => 'authorization, login'
    #
    # Usually you will not call this method directly. Use +title+, +keywords+,
    # +description+ for your daily tasks.
    #
    # See +display_meta_tags+ for allowed options.
    def set_meta_tags(meta_tags = {})
      @meta_tags ||= {}
      @meta_tags.merge!(meta_tags || {})
    end
  
    # Set the page title and return it back.
    #
    # This method is best suited for use in helpers. It sets the page title
    # and returns it (or +headline+ if specified).
    #
    # Examples:
    #   <%= title 'Login Page' %> => title='Login Page', return='Login Page'
    #   <%= title 'Login Page', 'Please login' %> => title='Login Page', return='Please Login'
    #
    # You can specify +title+ as a string or array:
    #   title :title => ['part1', 'part2']
    #   # part1 | part2
    def title(title, headline = '')
      set_meta_tags(:title => title)
      headline.blank? ? title : headline
    end
  
    # Set the page keywords.
    #
    # Keywords can be passed as string of comma-separated values, or as an array:
    #
    #   set_meta_tags :keywords => ['tag1', 'tag2']
    #   # tag1, tag2
    #
    # Examples:
    #   <% keywords 'keyword1, keyword2' %>
    #   <% keywords %w(keyword1 keyword2) %>
    def keywords(keywords)
      set_meta_tags(:keywords => keywords)
      keywords
    end
  
    # Set the page description.
    #
    # Description is a string (HTML will be stripped from output string).
    #
    # Examples:
    #   <% description 'This is login page' %>
    def description(description)
      set_meta_tags(:description => description)
      description
    end

    # Set the noindex meta tag
    #
    # You can specify noindex as a boolean or string 
    #
    # Examples:
    #   <% noindex true %>
    #   <% noindex 'googlebot' %>
    def noindex(noindex)
      set_meta_tags(:noindex => noindex)
      noindex
    end

    # Set the nofollow meta tag
    #
    # You can specify nofollow as a boolean or string 
    #
    # Examples:
    #   <% nofollow true %>
    #   <% nofollow 'googlebot' %>
    def nofollow(nofollow)
      set_meta_tags(:nofollow => nofollow)
      nofollow
    end
  
    # Set default meta tag values and display meta tags.
    #
    # This method should be used in layout file.
    #
    # Examples:
    #   <head>
    #     <%= display_meta_tags :site => 'My website' %>
    #   </head>
    #
    # Allowed options:
    # * <tt>:site</tt> -- site title;
    # * <tt>:title</tt> -- page title;
    # * <tt>:description</tt> -- page description;
    # * <tt>:keywords</tt> -- page keywords;
    # * <tt>:prefix</tt> -- text between site name and separator;
    # * <tt>:separator</tt> -- text used to separate website name from page title;
    # * <tt>:suffix</tt> -- text between separator and page title;
    # * <tt>:lowercase</tt> -- when true, the page name will be lowercase;
    # * <tt>:reverse</tt> -- when true, the page and site names will be reversed;
    # * <tt>:noindex</tt> -- add noindex meta tag; when true, 'robots' will be used, otherwise the string will be used;
    # * <tt>:nofollow</tt> -- add nofollow meta tag; when true, 'robots' will be used, otherwise the string will be used;
    # * <tt>:canonical</tt> -- add canonical link tag.
    def display_meta_tags(default = {})
      meta_tags = (default || {}).merge(@meta_tags || {})

      # Prefix (leading space)
      if meta_tags[:prefix]
        prefix = meta_tags[:prefix]
      elsif meta_tags[:prefix] === false
        prefix = ''
      else
        prefix = ' '
      end
    
      # Separator
      unless meta_tags[:separator].blank?
        separator = meta_tags[:separator]
      else
        separator = '|'
      end
    
      # Suffix (trailing space)
      if meta_tags[:suffix]
        suffix = meta_tags[:suffix]
      elsif meta_tags[:suffix] === false
        suffix = ''
      else
        suffix = ' '
      end
    
      # Title
      title = meta_tags[:title]
      if meta_tags[:lowercase] === true
        title = title.downcase unless title.blank?
      end
    
      # title
      if title.blank?
        result = content_tag :title, meta_tags[:site]
      else
        title = normalize_title(title)
        title = [meta_tags[:site]] + title
        title.reverse! if meta_tags[:reverse] === true
        sep = prefix + separator + suffix
        result = content_tag(:title, title.join(sep))
      end

      # description
      description = normalize_description(meta_tags[:description])
      result << "\n" + tag(:meta, :name => :description, :content => description) unless description.blank?
    
      # keywords
      keywords = normalize_keywords(meta_tags[:keywords])
      result << "\n" + tag(:meta, :name => :keywords, :content => keywords) unless keywords.blank?

      # noindex & nofollow
      noindex_name = meta_tags[:noindex].is_a?(String) ? meta_tags[:noindex] : 'robots'
      nofollow_name = meta_tags[:nofollow].is_a?(String) ? meta_tags[:nofollow] : 'robots'
  
      if noindex_name == nofollow_name
        content = [(meta_tags[:noindex] ? 'noindex' : nil), (meta_tags[:nofollow] ? 'nofollow' : nil)].compact.join(', ')
        result << "\n" + tag(:meta, :name => noindex_name, :content => content) unless content.blank?
      else
        result << "\n" + tag(:meta, :name => noindex_name, :content => 'noindex') if meta_tags[:noindex]
        result << "\n" + tag(:meta, :name => nofollow_name, :content => 'nofollow') if meta_tags[:nofollow]
      end

      # canonical
      result << "\n" + tag(:link, :rel => :canonical, :href => meta_tags[:canonical]) unless meta_tags[:canonical].blank?

      return result
    end
  
    private
  
      def normalize_title(title)
        if title.is_a? String
          title = [title]
        end
        title.map { |t| h(strip_tags(t)) }
      end
    
      def normalize_description(description)
        return '' unless description
        truncate(strip_tags(description).gsub(/\s+/, ' '), :length => 200)
      end
    
      def normalize_keywords(keywords)
        return '' unless keywords
        keywords = keywords.flatten.join(', ') if keywords.is_a?(Array)
        strip_tags(keywords).mb_chars.downcase
      end
  end
end
