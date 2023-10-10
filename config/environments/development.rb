Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  #Email server config 
  #config.action_mailer.smtp_settings = {
  #  :authentication => :plain,
  #  :address => ENV["MAILGUN_ADDRESS"],
  #  :port => 587,
  #  :domain => ENV["MAILGUN_DOMAIN"],
  #  :user_name => ENV["MAILGUN_USER_NAME"],
  #  :password => ENV["MAILGUN_PASSWORD"]
  #}

  # Aws ses email server global credentials
  config.action_mailer.smtp_settings = {
    :address => ENV["AWS_SES_ADDRESS"],
    :port => 587,
    :user_name => ENV["AWS_SES_USER"],
    :domain => ENV["AWS_SES_DOMAIN"],
    :password => ENV["AWS_SES_PASSWORD"],
    :authentication => :login,
    :enable_starttls_auto => true
  }

  # Stripe api test key 
  Stripe.api_key = ENV["STRIPE_KEY"]

  # Paypal sanbox test credencials
  PayPal::SDK.configure(
    :mode => ENV["PAYPAL_MODE"], # "sandbox" or "live"
    :client_id => ENV["PAYPAL_CLIENT_ID"],
    :client_secret => ENV["PAYPAL_CLIENT_SECRET"],
    :ssl_options => { } 
  )
  
  # Url login address
  config.login_path = ENV["LOGIN_PATH"]
  # Admin email prove
  config.admin_mail = ENV["ADMIN_EMAIL"]
  # Recovery login address
  config.recovery_password_path = ENV["RECOVERY_PASSWORD_PATH"]
  # Permisologies active or not
  config.permisology = true

  #Aws Credentials
  Aws.config.update({
    region: ENV["AWS_REGION"],
    credentials: Aws::Credentials.new(
      ENV["AWS_USER_NAME"], 
      ENV["AWS_PASSWORD"])
  })
  #Bucket AWS S3
  config.route = ENV["AWS_S3_ROUTE"]
  config.bucket = ENV["AWS_S3_BUCKET"]
  config.url_s3 = ENV["AWS_S3_URL"]

  #SlonAdmin
  config.slonemail = ENV["SLON_EMAIL"]

end
