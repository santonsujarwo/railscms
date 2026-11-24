require "active_support/core_ext/integer/time"
Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.public_file_server.headers = { "Cache-Control" => "public, max-age=31536000, immutable" }
  config.active_storage.service = ENV.fetch("ACTIVE_STORAGE_SERVICE", "r2").to_sym
  config.force_ssl = ENV.fetch("FORCE_SSL", "true") == "true"
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  # Keep jobs on the in-process adapter until Solid Queue tables and a worker
  # process are provisioned for Railway.
  config.active_job.queue_adapter = :async
  config.secret_key_base = ENV["SECRET_KEY_BASE"] if ENV["SECRET_KEY_BASE"].present?
end
