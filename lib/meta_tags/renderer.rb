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
      title = meta_tags.build_full_title
      normalized_meta_tags[:title] = title
      tags << ContentTag.new(:title, :content => title) if title.present?
    end

    def render_description(tags)
      description = TextNormalizer.normalize_description(meta_tags.delete(:description))
      normalized_meta_tags[:description] = description
      tags << Tag.new(:meta, :name => :description, :content => description) if description.present?
    end

    def render_keywords(tags)
      keywords = TextNormalizer.normalize_keywords(meta_tags.delete(:keywords))
      normalized_meta_tags[:keywords] = keywords
      tags << Tag.new(:meta, :name => :keywords, :content => keywords) if keywords.present?
    end

    def render_noindex(tags)
      noindex_name  = String === meta_tags[:noindex]  ? meta_tags[:noindex]  : 'robots'
      nofollow_name = String === meta_tags[:nofollow] ? meta_tags[:nofollow] : 'robots'

      if noindex_name == nofollow_name
        content = [meta_tags[:noindex] && 'noindex', meta_tags[:nofollow] && 'nofollow'].compact.join(', ')
        tags << Tag.new(:meta, :name => noindex_name, :content => content) if content.present?
      else
        tags << Tag.new(:meta, :name => noindex_name,  :content => 'noindex')  if meta_tags[:noindex] && meta_tags[:noindex] != false
        tags << Tag.new(:meta, :name => nofollow_name, :content => 'nofollow') if meta_tags[:nofollow] && meta_tags[:nofollow] != false
      end
      meta_tags.delete(:noindex)
      meta_tags.delete(:nofollow)
    end

    def render_refresh(tags)
      if refresh = meta_tags.delete(:refresh)
        tags << Tag.new(:meta, 'http-equiv' => 'refresh', :content => refresh.to_s) if refresh.present?
      end
    end

    def render_alternate(tags)
      if alternate = meta_tags.delete(:alternate)
        alternate.each do |hreflang, href|
          tags << Tag.new(:link, :rel => 'alternate', :href => href, :hreflang => hreflang) if href.present?
        end
      end
    end

    def render_links(tags)
      [ :canonical, :prev, :next, :author, :publisher ].each do |tag_name|
        href = meta_tags.delete(tag_name)
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
          meta_tags.delete(property)
        end
      end
    end

    def render_custom(tags)
      meta_tags.meta_tags.each do |name, data|
        Array(data).each do |val|
          tags << Tag.new(:meta, :name => name, :content => val)
        end
        meta_tags.delete(name)
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
