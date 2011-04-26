module MetaTags
  # Contains methods to use in controllers.
  #
  # You can define several instance variables to set meta tags:
  #   @page_title = 'Member Login'
  #   @page_description = 'Member login page.'
  #   @page_keywords = 'Site, Login, Members'
  #
  # Also you can use {InstanceMethods#set_meta_tags} method, that have the same parameters
  # as {ViewHelper#set_meta_tags}.
  #
  module ControllerHelper
    def self.included(base)
      base.send :include, InstanceMethods
      base.alias_method_chain :render, :meta_tags
      # TODO: It would be cleaner to use helper_method rather than repeat the methods in the view. Need to figure out how to test though.
      # base.send :helper_method, :set_meta_tags, :set_open_graph_meta_tags
    end

    module InstanceMethods
      # Processes the <tt>@page_title</tt>, <tt>@page_keywords</tt>, and
      # <tt>@page_description</tt> instance variables and calls +render+.
      def render_with_meta_tags(*args, &block)
        meta_tags = {}
        meta_tags[:title]       = @page_title       if @page_title
        meta_tags[:keywords]    = @page_keywords    if @page_keywords
        meta_tags[:description] = @page_description if @page_description
        set_meta_tags(meta_tags)

        render_without_meta_tags(*args, &block)
      end

      # Set meta tags for the page.
      #
      # See <tt>MetaTags.set_meta_tags</tt> for details.
      def set_meta_tags(meta_tags)
        @meta_tags ||= {}
        @meta_tags.merge!(meta_tags || {})
      end

      # Set Facebook Open Graph meta tags for the page.
      #
      # See <tt>MetaTags.set_meta_tags</tt> for details.
      def set_open_graph_meta_tags(fb_meta_tags)
        fb_formatted = fb_meta_tags.inject([]) do |collector, (key, value)|
          collector << [[:property, "og:#{key}"], [:content, value]]
        end
        
        # TODO: Maybe non_standard should be an accumulator rather than a merge?
        set_meta_tags :non_standard => fb_formatted
      end
      
      protected :set_meta_tags, :set_open_graph_meta_tags
    end
  end
end
