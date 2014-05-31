require 'raven'
require 'raven/sidekiq'

Raven.configure do |config|
  config.dsn = "https://#{Rails.application.secrets.sentry_public_key}:#{Rails.application.secrets.sentry_secret_key}@app.getsentry.com/#{Rails.application.secrets.sentry_project_id}"
  config.environments = %w[ production ]
  # override defaults in https://github.com/getsentry/raven-ruby/blob/master/lib/raven/configuration.rb#L79
  config.excluded_exceptions = []

  # use sidekiq to send errors
  config.async = lambda { |event|
    Raven.delay.send(event)
  }
end

