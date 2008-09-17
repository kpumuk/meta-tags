require File.dirname(__FILE__) + '/lib/meta_tags'
require File.dirname(__FILE__) + '/lib/meta_tags_controller_helper'

ActionView::Base.send :include, MetaTags
ActionController::Base.send :include, MetaTagsControllerHelper