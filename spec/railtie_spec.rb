# frozen_string_literal: true

require "spec_helper"

RSpec.describe MetaTags::Railtie do
  it "hooks helpers into Rails when the gem is loaded without an application boot" do
    script = <<~RUBY
      require "logger" # Required for Rails <= 7.0 on Ruby >= 3.1
      require "action_controller/railtie"
      require "action_view/railtie"
      require "meta_tags"

      abort "MetaTags::ControllerHelper is missing" unless ActionController::Base.included_modules.include?(MetaTags::ControllerHelper)
      abort "MetaTags::ViewHelper is missing" unless ActionView::Base.included_modules.include?(MetaTags::ViewHelper)
    RUBY

    loaded = system(RbConfig.ruby, "-I", File.expand_path("../lib", __dir__), "-e", script)

    expect(loaded).to be(true)
  end
end
