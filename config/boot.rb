# frozen_string_literal: true

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup"

if ENV["DISABLE_BOOTSNAP"] == "1"
  # Skip Bootsnap (e.g. in Docker with slow volume mounts)
else
  cache_dir = ENV["BOOTSNAP_CACHE_DIR"].presence || File.expand_path("../tmp/cache", __dir__)
  require "bootsnap"
  Bootsnap.setup(
    cache_dir: cache_dir,
    development_mode: ENV["RAILS_ENV"] != "production"
  )
end
