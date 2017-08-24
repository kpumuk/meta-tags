module MetaTags
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copy MetaTags default files"
      source_root File.expand_path('../templates', __FILE__)

      def copy_config
        template "config/initializers/meta_tags.rb"
      end
    end
  end
end
