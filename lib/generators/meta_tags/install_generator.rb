# frozen_string_literal: true

module MetaTags
  # Rails generators for MetaTags.
  module Generators
    # Installs the default MetaTags initializer into a Rails application.
    class InstallGenerator < Rails::Generators::Base
      desc "Copy MetaTags default files"
      source_root File.expand_path("templates", __dir__)

      # Copies the default MetaTags initializer template.
      #
      # @return [void]
      def copy_config
        template "config/initializers/meta_tags.rb"
      end
    end
  end
end
