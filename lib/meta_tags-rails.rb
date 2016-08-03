require 'action_controller'
require 'action_view'

# MetaTags gem namespace.
module MetaTags
  # Returns MetaTags gem configuration.
  #
  def self.config
    @@config ||= Configuration.new
  end

  # Configures MetaTags gem.
  #
  # @yield [Configuration] configuration object.
  # @example
  #
  #   MetaTags.configure do |config|
  #     # config.title_limit = 100
  #   end
  def self.configure
    yield config
  end
end

require 'meta_tags-rails/version'

require 'meta_tags-rails/configuration'
require 'meta_tags-rails/controller_helper'
require 'meta_tags-rails/meta_tags_collection'
require 'meta_tags-rails/renderer'
require 'meta_tags-rails/tag'
require 'meta_tags-rails/content_tag'
require 'meta_tags-rails/text_normalizer'
require 'meta_tags-rails/view_helper'

ActionView::Base.send :include, MetaTags::ViewHelper
ActionController::Base.send :include, MetaTags::ControllerHelper
