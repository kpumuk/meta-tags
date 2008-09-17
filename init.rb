require 'meta_tags'
ActionView::Base.send :include, MetaTags
ActionController::Base.send :include, MetaTagsControllerHelper