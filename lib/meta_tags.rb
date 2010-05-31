require 'action_controller'
require 'action_view'

module MetaTags
  autoload :ViewHelper,       'meta_tags/view_helper'
  autoload :ControllerHelper, 'meta_tags/controller_helper'
end

ActionView::Base.send :include, MetaTags::ViewHelper
ActionController::Base.send :include, MetaTags::ControllerHelper
