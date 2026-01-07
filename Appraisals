# frozen_string_literal: true

appraise "rails-6.1" do
  gem "railties", "~> 6.1.7"
  gem "zeitwerk", "~> 2.6.18" # 2.7+ requires Ruby 3.2, and we still support Ruby 3.1
  gem "base64" # not part of the default gems starting from Ruby 3.4.0
  gem "bigdecimal" # not part of the default gems starting from Ruby 3.4.0
  gem "logger" # not part of the default gems starting from Ruby 3.5.0
  gem "mutex_m" # not part of the default gems starting from Ruby 3.4.0
  gem "minitest", "< 6.0" # 6.0+ requires Ruby 3.2, and we still support Ruby 3.1
  gem "nokogiri", "< 1.19.0" # 1.19.0+ requires Ruby 3.2, and we still support Ruby 3.1
end

appraise "rails-7.0" do
  gem "railties", "~> 7.0.8"
  gem "zeitwerk", "~> 2.6.18" # 2.7+ requires Ruby 3.2, and we still support Ruby 3.1
  gem "base64" # not part of the default gems starting from Ruby 3.4.0
  gem "bigdecimal" # not part of the default gems starting from Ruby 3.4.0
  gem "logger" # not part of the default gems starting from Ruby 3.5.0
  gem "mutex_m" # not part of the default gems starting from Ruby 3.4.0
  gem "minitest", "< 6.0" # 6.0+ requires Ruby 3.2, and we still support Ruby 3.1
  gem "nokogiri", "< 1.19.0" # 1.19.0+ requires Ruby 3.2, and we still support Ruby 3.1
end

appraise "rails-7.1" do
  gem "railties", "~> 7.1.6"
  gem "zeitwerk", "~> 2.6.18" # 2.7+ requires Ruby 3.2, and we still support Ruby 3.1
  gem "securerandom", "0.3.0" # 0.4.0 requires ruby version >= 3.1.0
  gem "minitest", "< 6.0" # 6.0+ requires Ruby 3.2, and we still support Ruby 3.1
  gem "connection_pool", "< 3.0" # 3.0+ requires Ruby 3.2, and we still support Ruby 3.1
  gem "erb", "< 5.0" # 5.0+ requires Ruby 3.2, and we still support Ruby 3.1
  gem "nokogiri", "< 1.19.0" # 1.19.0+ requires Ruby 3.2, and we still support Ruby 3.1
end

appraise "rails-7.2" do
  gem "railties", "~> 7.2.3"
  gem "zeitwerk", "~> 2.6.18" # 2.7+ requires Ruby 3.2, and we still support Ruby 3.1
  gem "minitest", "< 6.0" # 6.0+ requires Ruby 3.2, and we still support Ruby 3.1
  gem "connection_pool", "< 3.0" # 3.0+ requires Ruby 3.2, and we still support Ruby 3.1
  gem "erb", "< 5.0" # 5.0+ requires Ruby 3.2, and we still support Ruby 3.1
  gem "nokogiri", "< 1.19.0" # 1.19.0+ requires Ruby 3.2, and we still support Ruby 3.1
end

appraise "rails-8.0" do
  gem "railties", "~> 8.0.4"
end

appraise "rails-8.1" do
  gem "railties", "~> 8.1.1"
end

appraise "rails-edge" do
  gem "railties", github: "rails"
end
