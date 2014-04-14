module MetaTags
  class Tag
    attr_reader :name, :options

    def initialize(name, options = {})
      @name = name
      @options = options
    end

    def render(view)
      view.tag(name, options)
    end
  end
end
