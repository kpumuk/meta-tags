module MetaTags
  class Renderer
    attr_reader :meta_tags, :normalized_meta_tags

    def initialize(meta_tags)
      @meta_tags = meta_tags
      @normalized_meta_tags = {}
    end

    def render(view)
      tags = []

      render_title(tags)
      render_description(tags)
      render_keywords(tags)
      render_refresh(tags)
      render_noindex(tags)
      render_alternate(tags)
      render_links(tags)

      render_hashes(tags)
      render_custom(tags)

      tags.compact.map { |tag| tag.render(view) }.join("\n").html_safe
    end

    protected

    def render_title(tags)
      title = meta_tags.extract_full_title
      normalized_meta_tags[:title] = title
      tags << ContentTag.new(:title, :content => title) if title.present?
    end

    def render_description(tags)
      description = TextNormalizer.normalize_description(meta_tags.extract(:description))
      normalized_meta_tags[:description] = description
      tags << Tag.new(:meta, :name => :description, :content => description) if description.present?
    end

    def render_keywords(tags)
      keywords = TextNormalizer.normalize_keywords(meta_tags.extract(:keywords))
      normalized_meta_tags[:keywords] = keywords
      tags << Tag.new(:meta, :name => :keywords, :content => keywords) if keywords.present?
    end

    def render_noindex(tags)
      meta_tags.extract_noindex.each do |name, content|
        tags << Tag.new(:meta, :name => name, :content => content) if content.present?
      end
    end

    def render_refresh(tags)
      if refresh = meta_tags.extract(:refresh)
        tags << Tag.new(:meta, 'http-equiv' => 'refresh', :content => refresh.to_s) if refresh.present?
      end
    end

    def render_alternate(tags)
      if alternate = meta_tags.extract(:alternate)
        alternate.each do |hreflang, href|
          tags << Tag.new(:link, :rel => 'alternate', :href => href, :hreflang => hreflang) if href.present?
        end
      end
    end

    def render_links(tags)
      [ :canonical, :prev, :next, :author, :publisher ].each do |tag_name|
        href = meta_tags.extract(tag_name)
        if href.present?
          @normalized_meta_tags[tag_name] = href
          tags << Tag.new(:link, :rel => tag_name, :href => href)
        end
      end
    end

    def render_hashes(tags)
      meta_tags.meta_tags.each do |property, data|
        if data.is_a?(Hash)
          tags.concat process_tree(property, data)
          meta_tags.extract(property)
        end
      end
    end

    def render_custom(tags)
      meta_tags.meta_tags.each do |name, data|
        Array(data).each do |val|
          tags << Tag.new(:meta, :name => name, :content => val)
        end
        meta_tags.extract(name)
      end
    end

    # Recursive function to process all the hashes and arrays on meta tags
    def process_tree(property, content)
      result = []
      if content.is_a?(Hash)
        content.each do |key, value|
          result.concat process_tree("#{property}:#{key}", value.is_a?(Symbol) ? normalized_meta_tags[value] : value)
        end
      else
        Array(content).each do |c|
          if c.is_a?(Hash)
            result.concat process_tree(property, c)
          else
            result << Tag.new(:meta, :property => "#{property}", :content => c) unless c.blank?
          end
        end
      end
      result
    end
  end
end
