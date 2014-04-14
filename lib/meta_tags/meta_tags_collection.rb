module MetaTags
  class MetaTagsCollection
    attr_reader :meta_tags

    def initialize
      @meta_tags = HashWithIndifferentAccess.new
    end

    def [](name)
      @meta_tags[name]
    end

    def []=(name, value)
      @meta_tags[name] = value
    end

    def update(meta_tags = {})
      @meta_tags.deep_merge! normalize_open_graph(meta_tags)
    end

    def with_defaults(defaults = {})
      old_meta_tags = @meta_tags
      @meta_tags = normalize_open_graph(defaults).deep_merge!(self.meta_tags)
      yield
    ensure
      @meta_tags = old_meta_tags
    end

    def full_title(defaults = {})
      with_defaults(defaults) { build_full_title  }
    end

    def delete(key)
      @meta_tags.delete(key)
    end

    def build_full_title
      # Prefix (leading space)
      prefix = meta_tags[:prefix] === false ? '' : (meta_tags[:prefix] || ' ')
      meta_tags.delete(:prefix)

      # Separator
      separator = meta_tags[:separator] === false ? '' : (meta_tags[:separator] || '|')

      # Suffix (trailing space)
      suffix = meta_tags[:suffix] === false ? '' : (meta_tags[:suffix] || ' ')
      meta_tags.delete(:suffix)

      # Special case: if separator is hidden, do not display suffix/prefix
      if meta_tags[:separator] == false
        prefix = suffix = ''
      end
      meta_tags.delete(:separator)

      # Title
      title = meta_tags.delete(:title)
      if meta_tags.delete(:lowercase) === true and title.present?
        title = Array(title).map { |t| t.downcase }
      end

      # title
      if title.blank?
        meta_tags.delete(:reverse)
        meta_tags.delete(:site)
      else
        title = TextNormalizer.normalize_title(title)
        title.unshift(meta_tags[:site]) if meta_tags[:site].present?
        title.reverse! if meta_tags.delete(:reverse) === true
        sep = TextNormalizer.safe_join([prefix, separator, suffix], '')
        title = TextNormalizer.safe_join(title, sep)
        meta_tags.delete(:site)
        # We escaped every chunk of the title, so the whole title should be HTML safe
        title.html_safe
      end
    end

    def normalize_open_graph(meta_tags)
      meta_tags = (meta_tags || {}).with_indifferent_access
      meta_tags[:og] = meta_tags.delete(:open_graph) if meta_tags.key?(:open_graph)
      meta_tags
    end
  end
end
