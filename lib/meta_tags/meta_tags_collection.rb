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
      separator = extract_separator
      title = extract_title || []

      site_title = meta_tags[:site].presence
      title.unshift(site_title) if site_title
      title = TextNormalizer.normalize_title(title)

      title.reverse! if meta_tags.delete(:reverse) === true
      title = TextNormalizer.safe_join(title, separator)
      meta_tags.delete(:site)

      title
    end

    def extract_separator
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

      TextNormalizer.safe_join([prefix, separator, suffix], '')
    end

    def extract_title
      title = meta_tags.delete(:title).presence
      return unless title

      title = Array(title)
      title.each(&:downcase!) if meta_tags.delete(:lowercase) === true
      title
    end

    def normalize_open_graph(meta_tags)
      meta_tags = (meta_tags || {}).with_indifferent_access
      meta_tags[:og] = meta_tags.delete(:open_graph) if meta_tags.key?(:open_graph)
      meta_tags
    end
  end
end
