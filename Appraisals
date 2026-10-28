# frozen_string_literal: true

appraise "rails-6.1" do
  gem "railties", "~> 6.1.7"
  gem "zeitwerk"
  gem "base64" # not part of the default gems starting from Ruby 3.4.0
  gem "benchmark" # not part of the default gems starting from Ruby 4.0.0
  gem "bigdecimal" # not part of the default gems starting from Ruby 3.4.0
  gem "logger" # not part of the default gems starting from Ruby 3.5.0
  gem "mutex_m" # not part of the default gems starting from Ruby 3.4.0
  gem "minitest", "< 6.0" # Minitest 6 is incompatible with this Rails version.
  gem "parallel", "< 2.0" # 2.0+ requires Ruby 3.3, and we still support Ruby 3.2
end

appraise "rails-7.0" do
  gem "railties", "~> 7.0.8"
  gem "zeitwerk"
  gem "base64" # not part of the default gems starting from Ruby 3.4.0
  gem "bigdecimal" # not part of the default gems starting from Ruby 3.4.0
  gem "logger" # not part of the default gems starting from Ruby 3.5.0
  gem "mutex_m" # not part of the default gems starting from Ruby 3.4.0
  gem "minitest", "< 6.0" # Minitest 6 is incompatible with this Rails version.
  gem "parallel", "< 2.0" # 2.0+ requires Ruby 3.3, and we still support Ruby 3.2
end

appraise "rails-7.1" do
  gem "railties", "~> 7.1.6"
  gem "zeitwerk"
  gem "securerandom"
  gem "minitest", "< 6.0" # Minitest 6 is incompatible with this Rails version.
  gem "connection_pool"
  gem "erb"
  gem "parallel", "< 2.0" # 2.0+ requires Ruby 3.3, and we still support Ruby 3.2
end

appraise "rails-7.2" do
  gem "railties", "~> 7.2.3"
  gem "zeitwerk"
  gem "minitest", "< 6.0" # Minitest 6 is incompatible with this Rails version.
  gem "connection_pool"
  gem "erb"
  gem "parallel", "< 2.0" # 2.0+ requires Ruby 3.3, and we still support Ruby 3.2
end

appraise "rails-8.0" do
  gem "railties", "~> 8.0.4"
  gem "parallel", "< 2.0" # 2.0+ requires Ruby 3.3, and we still support Ruby 3.2
  gem "bundler-audit", "0.9.3"
end

appraise "rails-8.1" do
  gem "railties", "~> 8.1.1"
  gem "parallel", "< 2.0" # 2.0+ requires Ruby 3.3, and we still support Ruby 3.2
end

appraise "rails-edge" do
  gem "railties", github: "rails"
end
