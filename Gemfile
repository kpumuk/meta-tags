# frozen_string_literal: true

source "https://rubygems.org"

# Specify gem's dependencies in meta-tags.gemspec
gemspec

unless ENV["NO_STEEP"] == "1"
  # Ruby typings
  gem "steep", "~> 1.3.0", platform: :mri
end

gem "standard", github: "palkan/standard", branch: "fix/extend-config-default-configuration-extensions"
