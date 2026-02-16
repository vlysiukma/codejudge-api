# frozen_string_literal: true

require "active_model/railtie"
require "active_job/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_record/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module Codejudge
  class Application < Rails::Application
    config.load_defaults 8.0
    config.api_only = true
    config.secret_key_base = ENV.fetch("SECRET_KEY_BASE") { "dev_secret_key_base_#{Rails.env}_min_32_chars_long" }
  end
end
