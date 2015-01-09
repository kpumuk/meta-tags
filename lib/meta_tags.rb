require 'action_controller'
require 'action_view'

# MetaTags gem namespace.
module MetaTags
  def self.truncate_description_at_length=(truncate_at)
    @truncate_description_at_length = truncate_at
  end

  def self.truncate_description_at_length
    @truncate_description_at_length ||= 200
  end
end

require 'meta_tags/version'

require 'meta_tags/controller_helper'
require 'meta_tags/meta_tags_collection'
require 'meta_tags/renderer'
require 'meta_tags/tag'
require 'meta_tags/content_tag'
require 'meta_tags/text_normalizer'
require 'meta_tags/view_helper'

ActionView::Base.send :include, MetaTags::ViewHelper
ActionController::Base.send :include, MetaTags::ControllerHelper
