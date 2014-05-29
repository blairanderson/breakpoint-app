require 'raven'
require 'raven/sidekiq'

Raven.configure do |config|
  config.dsn = "https://#{Rails.application.secrets.sentry_public_key}:#{Rails.application.secrets.sentry_secret_key}@app.getsentry.com/#{Rails.application.secrets.sentry_project_id}"
  config.environments = %w[ production ]
end

