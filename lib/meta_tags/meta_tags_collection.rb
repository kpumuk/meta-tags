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
      with_defaults(defaults) { extract_full_title  }
    end

    def extract(key)
      @meta_tags.delete(key)
    end

    def delete(*keys)
      keys.each { |key| @meta_tags.delete(key) }
    end

    def extract_full_title
      title = extract_title || []
      separator = extract_separator

      site_title = extract(:site).presence
      title.unshift(site_title) if site_title
      title = TextNormalizer.normalize_title(title)

      title.reverse! if extract(:reverse) === true
      title = TextNormalizer.safe_join(title, separator)

      title
    end

    def extract_title
      title = extract(:title).presence
      return unless title

      title = Array(title)
      title.each(&:downcase!) if extract(:lowercase) === true
      title
    end

    def extract_separator
      if meta_tags[:separator] === false
        # Special case: if separator is hidden, do not display suffix/prefix
        prefix = separator = suffix = ''
      else
        prefix    = extract_separator_section(:prefix, ' ')
        separator = extract_separator_section(:separator, '|')
        suffix    = extract_separator_section(:suffix, ' ')
      end
      delete(:separator, :prefix, :suffix)

      TextNormalizer.safe_join([prefix, separator, suffix], '')
    end

    def extract_noindex
      noindex_name,  noindex_value  = extract_noindex_attribute(:noindex)
      nofollow_name, nofollow_value = extract_noindex_attribute(:nofollow)

      if noindex_name == nofollow_name
        { noindex_name => [noindex_value, nofollow_value].compact.join(', ') }
      else
        { noindex_name => noindex_value, nofollow_name => nofollow_value }
      end
    end

    protected

    def normalize_open_graph(meta_tags)
      meta_tags = (meta_tags || {}).with_indifferent_access
      meta_tags[:og] = meta_tags.delete(:open_graph) if meta_tags.key?(:open_graph)
      meta_tags
    end

    def extract_separator_section(name, default)
      meta_tags[name] === false ? '' : (meta_tags[name] || default)
    end

    def extract_noindex_attribute(name)
      noindex       = extract(name)
      noindex_name  = String === noindex ? noindex : 'robots'
      noindex_value = noindex ? name.to_s : nil

      [ noindex_name, noindex_value ]
    end
  end
end
