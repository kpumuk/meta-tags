module MetaTags
  module TextNormalizer
    def self.normalize_title(title)
      Array(title).map { |t| strip_tags(t) }
    end

    def self.normalize_description(description)
      return '' if description.blank?
      helpers.truncate(strip_tags(description).gsub(/\s+/, ' '), :length => 200)
    end

    def self.normalize_keywords(keywords)
      return '' if keywords.blank?
      keywords = keywords.flatten.join(', ') if Array === keywords
      strip_tags(keywords).downcase.to_s
    end

    def self.helpers
      ActionController::Base.helpers
    end

    def self.strip_tags(str)
      helpers.strip_tags(str)
    end

    def self.html_escape(str)
      ERB::Util.html_escape(str)
    end

    def self.safe_join(array, sep=$,)
      helpers.safe_join(array, sep)
    end
  end
end
