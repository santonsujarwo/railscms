require "devise/orm/active_record"

Devise.setup do |config|
  config.mailer_sender = ENV.fetch("MAILER_SENDER", "no-reply@example.com")
  config.parent_controller = "ApplicationController"
  config.password_length = 12..128
  config.sign_out_via = :delete
  config.reconfirmable = false
  config.expire_all_remember_me_on_sign_out = true
end
