module MetaTags
  # Contains methods to use in controllers.
  #
  # You can define several instance variables to set meta tags:
  #   @page_title = 'Member Login'
  #   @page_description = 'Member login page.'
  #   @page_keywords = 'Site, Login, Members'
  #
  # Also you can use {#set_meta_tags} method, that have the same parameters
  # as {ViewHelper#set_meta_tags}.
  #
  module ControllerHelper
    extend ActiveSupport::Concern

    included do
      alias_method_chain :render, :meta_tags
      before_filter :meta_tags_from_locales
    end

    # Processes the <tt>@page_title</tt>, <tt>@page_keywords</tt>, and
    # <tt>@page_description</tt> instance variables and calls +render+.
    def render_with_meta_tags(*args, &block)
      self.meta_tags[:title]       = @page_title       if @page_title
      self.meta_tags[:keywords]    = @page_keywords    if @page_keywords
      self.meta_tags[:description] = @page_description if @page_description

      render_without_meta_tags(*args, &block)
    end
    protected :render_with_meta_tags

    # Processes meta tags from locales file in the name space
    # [locale].meta_tags.[controller_name].[action].[title|description|keywords]
    # So en.meta_tags.visitors.index.title would be loaded as title for default
    # welcome page in the visitors controller in english.
    def meta_tags_from_locales
      name_space = "meta_tags.#{controller_name}.#{action_name}"

      self.meta_tags[:title]       = I18n.t("#{name_space}.title") unless I18n.t("#{name_space}.title", default: '').blank?
      self.meta_tags[:keywords]    = I18n.t("#{name_space}.keywords") unless I18n.t("#{name_space}.keywords", default: '').blank?
      self.meta_tags[:description] = I18n.t("#{name_space}.description") unless I18n.t("#{name_space}.description", default: '').blank?
    end
    protected :meta_tags_from_locales

    # Set meta tags for the page.
    #
    # See <tt>MetaTags::ViewHelper#set_meta_tags</tt> for details.
    def set_meta_tags(meta_tags)
      self.meta_tags.update(meta_tags)
    end
    protected :set_meta_tags

    # Get meta tags for the page.
    def meta_tags
      @meta_tags ||= MetaTagsCollection.new
    end
    protected :meta_tags
  end
end
