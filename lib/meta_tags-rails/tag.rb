module MetaTags
  # Represents an HTML meta tag with no content (<tag />).
  class Tag
    attr_reader :name, :attributes

    # Initializes a new instance of Tag class.
    #
    # @param [String, Symbol] name HTML tag name
    # @param [Hash] attributes list of HTML tag attributes
    #
    def initialize(name, attributes = {})
      @name = name
      @attributes = attributes
    end

    # Render tag into a Rails view.
    #
    # @param [ActionView::Base] view instance of a Rails view.
    # @return [String] HTML string for the tag.
    #
    def render(view)
      view.tag(name, attributes)
    end
  end
end
