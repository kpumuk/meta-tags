module MetaTagsControllerHelper
  def self.included(base)
    base.send :include, InstanceMethods
    base.class_eval do
      alias_method_chain :render, :meta_tags
    end
  end

  module InstanceMethods
    protected

      def render_with_meta_tags(options = nil, extra_options = {}, &block)
        meta_tags = {}
        meta_tags[:title] = @page_title if @page_title
        meta_tags[:keywords] = @page_keywords if @page_keywords
        meta_tags[:description] = @page_description if @page_description
        set_meta_tags(meta_tags)

        render_without_meta_tags(options, extra_options, &block)
      end
      
      def set_meta_tags(meta_tags)
        @meta_tags ||= {}
        @meta_tags.merge!(meta_tags || {})
      end
  end
end