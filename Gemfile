# frozen_string_literal: true

source "https://rubygems.org"

ruby "~> 3.3.0"

gem "rails", "~> 8.0"
gem "pg", "~> 1.5"
gem "puma", ">= 6.4"
gem "redis", "~> 5.0"
gem "jwt_sessions", "~> 3.2"
gem "bcrypt", "~> 3.1"
gem "rack-cors"

gem "bootsnap", require: false
gem "tzinfo-data", platforms: %w[windows jruby]

group :development, :test do
  gem "debug", platforms: %w[mingw mswin x64_mingw]
  gem "rspec-rails", "~> 7.0"
  gem "factory_bot_rails", "~> 6.4"
  gem "database_cleaner-active_record", "~> 2.2"
end

group :development do
  gem "listen"
end
