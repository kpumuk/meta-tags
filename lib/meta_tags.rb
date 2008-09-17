module MetaTags
  def set_meta_tags(meta_tags = {})
    @meta_tags ||= {}
    @meta_tags.merge!(meta_tags || {})
  end
  
  def title(title, headline = '')
    set_meta_tags(:title => title)
    headline.blank? ? title : headline
  end
  
  def keywords(keywords)
    set_meta_tags(:keywords => keywords)
    keywords
  end
  
  def description(description)
    set_meta_tags(:description => description)
    description
  end
  
  def display_meta_tags(default = {})
    meta_tags = (default || {}).merge(@meta_tags || {})

    # Prefix (leading space)
    if meta_tags[:prefix]
      prefix = meta_tags[:prefix]
    elsif meta_tags[:prefix] === false
      prefix = ''
    else
      prefix = ' '
    end
    
    # Separator
    unless meta_tags[:separator].blank?
      separator = meta_tags[:separator]
    else
      separator = '|'
    end
    
    # Suffix (trailing space)
    if meta_tags[:suffix]
      suffix = meta_tags[:suffix]
    elsif meta_tags[:suffix] === false
      suffix = ''
    else
      suffix = ' '
    end
    
    # Title
    title = meta_tags[:title]
    if meta_tags[:lowercase] === true
      title = title.downcase unless title.blank?
    end
    
    if title.blank?
      result = content_tag :title, meta_tags[:site]
    else
      title = normalize_title(title)
      title = [meta_tags[:site]] + title
      title.reverse! if meta_tags[:reverse] === true
      sep = prefix + separator + suffix
      result = content_tag(:title, title.join(sep))
    end

    description = normalize_description(meta_tags[:description])
    result << "\n" + tag(:meta, :name => :description, :content => description) unless description.blank?
    
    keywords = normalize_keywords(meta_tags[:keywords])
    result << "\n" + tag(:meta, :name => :keywords, :content => keywords) unless keywords.blank?

    return result
  end
  
  private
  
    def normalize_title(title)
      if title.is_a? String
        title = [title]
      end
      title.map { |t| h(strip_tags(t)) }
    end
    
    def normalize_description(description)
      return '' unless description
      truncate(strip_tags(description).gsub(/\s+/, ' '), 200, '...')
    end
    
    def normalize_keywords(keywords)
      return '' unless keywords
      keywords = keywords.flatten.join(', ') if keywords.is_a?(Array)
      strip_tags(keywords).chars.downcase
    end
end
