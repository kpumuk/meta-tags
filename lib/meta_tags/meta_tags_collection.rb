# frozen_string_literal: true

module MetaTags
  # This class represents a collection of meta tags. Basically a wrapper around
  # HashWithIndifferentAccess, with some additional helper methods.
  class MetaTagsCollection
    attr_reader :meta_tags

    # Initializes a new instance of MetaTagsCollection.
    def initialize
      @meta_tags = ActiveSupport::HashWithIndifferentAccess.new
    end

    # Returns meta tag value by name.
    #
    # @param name [String, Symbol] meta tag name.
    # @return meta tag value.
    def [](name)
      @meta_tags[name]
    end

    # Sets meta tag value by name.
    #
    # @param name [String, Symbol] meta tag name.
    # @param value meta tag value.
    # @return meta tag value.
    def []=(name, value)
      @meta_tags[name] = value
    end

    # Recursively merges a Hash of meta tag attributes into the current list.
    #
    # @param object [Hash, #to_meta_tags] Hash of meta tags (or object responding
    #   to #to_meta_tags and returning a hash) to merge into the current list.
    # @return [Hash] result of the merge.
    def update(object = {})
      meta_tags = if object.respond_to?(:to_meta_tags)
        # @type var object: _MetaTagish & Object
        object.to_meta_tags
      else
        # @type var object: Hash[String | Symbol, untyped]
        object
      end
      @meta_tags.deep_merge! normalize_open_graph(meta_tags)
    end

    # Temporarily merges defaults with the current meta tags list and yields the block.
    #
    # @param defaults [Hash] list of default meta tag attributes.
    # @return result of the block call.
    def with_defaults(defaults = {})
      old_meta_tags = @meta_tags
      @meta_tags = normalize_open_graph(defaults).deep_merge!(@meta_tags)
      yield
    ensure
      @meta_tags = old_meta_tags
    end

    # Constructs the full title as if it would be rendered in title meta tag.
    #
    # @param defaults [Hash] list of default meta tag attributes.
    # @return [String] page title.
    def full_title(defaults = {})
      with_defaults(defaults) { extract_full_title }
    end

    # Constructs the title without site title (for normalized parameters). When title is empty,
    # use the site title instead.
    #
    # @param defaults [Hash] list of default meta tag attributes.
    # @return [String] page title.
    def page_title(defaults = {})
      with_defaults(defaults) do
        site = extract(:site)
        extract_full_title.presence || site || ""
      end
    end

    # Deletes and returns a meta tag value by name.
    #
    # @param name [String, Symbol] meta tag name.
    # @return [Object] meta tag value.
    def extract(name)
      @meta_tags.delete(name)
    end

    # Deletes specified meta tags.
    #
    # @param names [Array<String, Symbol>] list of meta tags to delete.
    def delete(*names)
      names.each { |name| @meta_tags.delete(name) }
    end

    # Extracts full page title and deletes all related meta tags.
    #
    # @return [String] page title.
    def extract_full_title
      site_title = extract(:site) || ""
      title = extract_title
      separator = extract_separator
      reverse = extract(:reverse) == true

      TextNormalizer.normalize_title(site_title, title, separator, reverse)
    end

    # Extracts page title as an array of segments without site title and separators.
    #
    # @return [Array<String>] segments of page title.
    def extract_title
      title = extract(:title).presence
      return [] unless title

      # @type var title: Array[String]
      title = Array(title)
      return title.map(&:downcase) if extract(:lowercase) == true

      title
    end

    # Extracts title separator as a string.
    #
    # @return [String] page title separator.
    def extract_separator
      if meta_tags[:separator] == false
        # Special case: if separator is hidden, do not display suffix/prefix
        prefix = separator = suffix = ""
      else
        prefix = extract_separator_section(:prefix, " ")
        separator = extract_separator_section(:separator, "|")
        suffix = extract_separator_section(:suffix, " ")
      end
      delete(:separator, :prefix, :suffix)

      TextNormalizer.safe_join([prefix, separator, suffix], "")
    end

    # Extracts robots settings as a Hash mapping tag names to rendered values.
    #
    # @return [Hash{String => String}] robots attributes.
    def extract_robots
      result = robots
      delete(:noindex, :index, :follow, :nofollow, :noarchive)
      [:robots, :googlebot, :bingbot].each do |bot|
        extract(bot) if meta_tags[bot].is_a?(Hash)
      end

      result
    end

    # Returns whether robots settings produce a noindex directive.
    #
    # @return [Boolean] true when a noindex directive will be rendered.
    def noindex?
      contents = robots.values
      property_tags = MetaTags.config.property_tags.map(&:to_s)
      [:robots, :googlebot, :bingbot].each do |bot|
        values = meta_tags[bot]
        next if values.is_a?(Hash) || property_tags.include?(bot.to_s)

        contents.concat(Array(values))
      end

      contents.any? do |content|
        content.to_s.split(",").any? { |directive| directive.strip.casecmp?("noindex") }
      end
    end

    protected

    # Returns robots settings without modifying the collection.
    #
    # @return [Hash{String => String}] robots attributes.
    def robots
      # @type var result: Hash[String, Array[String]]
      result = Hash.new { |h, k| h[k] = [] }

      [
        # noindex has higher priority than index
        [:noindex, :index],
        # follow has higher priority than nofollow
        [:follow, :nofollow],
        :noarchive
      ].each do |attributes|
        calculate_robots_attributes(result, attributes)
      end

      [:robots, :googlebot, :bingbot].each do |bot|
        values = meta_tags[bot]
        if values.is_a?(Hash)
          values.each do |key, value|
            next if value == false

            directive = (value.nil? || value == true) ? key.to_s : "#{key}:#{value}"
            result[bot.to_s] << directive
          end
        end
      end

      result.transform_values { |v| v.join(", ") }
    end

    # Converts input hash to HashWithIndifferentAccess and renames :open_graph to :og.
    #
    # @param meta_tags [Hash] list of meta tags.
    # @return [ActiveSupport::HashWithIndifferentAccess] normalized meta tags list.
    def normalize_open_graph(meta_tags)
      meta_tags = meta_tags.with_indifferent_access
      meta_tags[:og] = meta_tags.delete(:open_graph) if meta_tags.key?(:open_graph)
      meta_tags
    end

    # Extracts separator segment without deleting it from meta tags list.
    # If the value is false, an empty string will be returned.
    #
    # @param name [Symbol, String] separator segment name.
    # @param default [String] default value.
    # @return [String] separator segment value.
    def extract_separator_section(name, default)
      (meta_tags[name] == false) ? "" : (meta_tags[name] || default)
    end

    # Extracts a robots attribute name/value pair (noindex, nofollow, etc.).
    #
    # @param name [String, Symbol] noindex attribute name.
    # @return [Array<Object>] normalized robots tag name(s) and directive value.
    def extract_robots_attribute(name)
      noindex = meta_tags[name]
      noindex_name = if noindex.is_a?(Array)
        noindex.map(&:to_s)
      elsif noindex.is_a?(String)
        noindex
      else
        "robots"
      end
      noindex_value = robots_attribute_present?(noindex) ? name.to_s : nil

      [noindex_name, noindex_value]
    end

    # Returns whether a robots attribute resolves to at least one target.
    #
    # @param value [Object] robots attribute value.
    # @return [Boolean] true when the attribute produces a directive.
    def robots_attribute_present?(value)
      !!value && (!value.is_a?(Array) || !value.empty?)
    end

    # Appends resolved robots directives while preserving first-write priority.
    #
    # @param result [Hash{String => Array<String>}] robots directives grouped by tag name.
    # @param attributes [Symbol, Array<Symbol>] robots attributes to resolve.
    # @return [void]
    def calculate_robots_attributes(result, attributes)
      processed = Set.new
      Array(attributes).each do |attribute|
        # @type var attribute: String | Symbol
        names, value = extract_robots_attribute(attribute)
        next unless value

        robot_names = names.is_a?(String) ? [names] : names
        robot_names.each do |name|
          apply_robots_value(result, name, value, processed)
        end
      end
    end

    # Records a robots directive unless it has already been set for the same key.
    #
    # @param result [Hash{String => Array<String>}] robots directives grouped by tag name.
    # @param name [String] robots tag name.
    # @param value [String] robots directive value.
    # @param processed [Set<String>] names already recorded in this pass.
    # @return [void]
    def apply_robots_value(result, name, value, processed)
      name = name.to_s
      return if processed.include?(name)

      result[name] << value
      processed << name
    end
  end
end
