# frozen_string_literal: true

# Pretend we are a normal Rails application to trigger all the initializers
# that are normally happen during Rails boot process. This is done to properly
# test Railtie used by this gem to properly integrate into the Rails.
#
# TLDR. This is a real Rails application

require 'rails'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'meta_tags/railtie'

module MetaTagsRailsApp
  class Application < Rails::Application
    config.secret_token = '572c86f5ede338bd8aba8dae0fd3a326aabababc98d1e6ce34b9f5'
    config.eager_load = false
  end

  class MetaTagsController < ActionController::Base
    include MetaTags::ControllerHelper

    def index
      @page_title       = 'title'
      @page_keywords    = 'key1, key2, key3'
      @page_description = 'description'

      render plain: '_rendered_'
    end

    def show
      render plain: '_rendered_'
    end

    def hide
      @page_title       = nil
      @page_keywords    = nil
      @page_description = nil

      render plain: '_rendered_'
    end

    public :set_meta_tags, :meta_tags
  end

  class MetaTagsView < ActionView::Base
    include MetaTags::ViewHelper
  end
end

# Alright, we're all set. Let's boot!
Rails.application.initialize!
