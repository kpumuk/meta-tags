# frozen_string_literal: true

target :lib do
  signature "sig"

  check "lib"
  # check "Gemfile"

  # We don't want to type check Rails/RSpec related code
  # (because we don't have RBS files for it)
  ignore "lib/meta_tags/railtie.rb"
  ignore "lib/generators"
end
