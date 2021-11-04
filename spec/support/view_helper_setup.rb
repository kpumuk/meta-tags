# frozen_string_literal: true

RSpec.configure do |config|
  config.define_derived_metadata(file_path: %r{spec/view_helper}) do |metadata|
    metadata[:type] = :view_helper
  end
end

RSpec.shared_context "with an initialized view", type: :view_helper do
  subject do
    assigns = {}
    controller = nil
    MetaTagsRailsApp::MetaTagsView.new(ActionView::LookupContext.new([]), assigns, controller)
  end
end
