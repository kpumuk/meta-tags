module MetaTags
  class ContentTag < Tag
    def render(view)
      view.content_tag(name, options.delete(:content), options)
    end
  end
end
