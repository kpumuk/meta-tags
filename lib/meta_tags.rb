require 'action_controller'
require 'action_view'

module MetaTags
end

require 'meta_tags/version'
require 'meta_tags/view_helper'
require 'meta_tags/controller_helper'

ActionView::Base.send :include, MetaTags::ViewHelper
ActionController::Base.send :include, MetaTags::ControllerHelper
