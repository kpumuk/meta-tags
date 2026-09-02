# frozen_string_literal: true

module MetaTags
  # Registers the MetaTags deprecator with the Rails application.
  class Railtie < Rails::Railtie
    initializer "meta_tags.register_deprecator", before: :load_environment_config do |app|
      app.deprecators[:meta_tags] = MetaTags.deprecator if app.respond_to?(:deprecators)
    end
  end

  # Hooks MetaTags helpers into Rails controllers and views. Registering a load
  # hook is lazy, so it does not have to wait for an application to boot.
  ActiveSupport.on_load :action_controller do
    include MetaTags::ControllerHelper
  end

  ActiveSupport.on_load :action_view do
    include MetaTags::ViewHelper
  end
end
