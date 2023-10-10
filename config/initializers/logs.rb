#ActiveRecord::Base.logger = nil

PayPal::SDK.logger = Logger.new(STDERR)

# change log level to INFO
PayPal::SDK.logger.level = Logger::INFO