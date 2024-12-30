# config/environments/development.rb
Rails.application.configure do
  # Add this block for email delivery configuration
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    user_name: ENV["DEFAULT_EMAIL"],  # Use environment variable for your email
    password: ENV["DEFAULT_PASSWORD"],  # Use environment variable for password
    authentication: "plain",
    enable_starttls_auto: true
  }

  config.action_mailer.default_url_options = { host: "localhost", port: 3000 }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true  # Ensure any errors in email delivery are raised
  config.log_level = :debug

  config.active_storage.service = :local

  config.eager_load = false
end
