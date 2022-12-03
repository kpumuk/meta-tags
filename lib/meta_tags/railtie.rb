# frozen_string_literal: true

module MetaTags
  class Railtie < Rails::Railtie
    initializer "meta_tags.setup_action_controller" do
      ActiveSupport.on_load :action_controller do
        include MetaTags::ControllerHelper
      end
    end

    initializer "meta_tags.setup_action_view" do
      ActiveSupport.on_load :action_view do
        include MetaTags::ViewHelper
      end
    end
  end
end
