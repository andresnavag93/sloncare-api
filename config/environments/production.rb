Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # Mount Action Cable outside main process or domain
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment)
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "backend2_0_#{Rails.env}"

  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

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
