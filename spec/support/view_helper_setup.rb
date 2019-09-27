# frozen_string_literal: true

RSpec.configure do |config|
  config.define_derived_metadata(file_path: %r{spec/view_helper}) do |metadata|
    metadata[:type] = :view_helper
  end
end

RSpec.shared_examples "initialize a view for the view helpers", type: :view_helper do
  subject do
    ActionView::Base.new(ActionView::LookupContext.new([]))
  end
end
