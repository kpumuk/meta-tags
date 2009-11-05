module MetaTags
end

require File.dirname(__FILE__) + '/meta_tags/view_helper'
require File.dirname(__FILE__) + '/meta_tags/controller_helper'

ActionView::Base.send :include, MetaTags::ViewHelper
ActionController::Base.send :include, MetaTags::ControllerHelper
