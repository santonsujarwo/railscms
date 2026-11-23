require_relative "boot"
require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"
require "active_storage/engine"
require "action_cable/engine"
Bundler.require(*Rails.groups)

module RailsCms
  class Application < Rails::Application
    config.load_defaults 8.0
    config.time_zone = "Asia/Jakarta"
    config.i18n.default_locale = :en
    config.active_job.queue_adapter = :solid_queue
    config.active_storage.variant_processor = :vips
  end
end
