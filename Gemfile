source 'https://rubygems.org'

gem 'rails', '3.2.8'
gem 'pg'

group :development do
  gem 'quiet_assets'
  #gem 'mailcatcher'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'capybara'
  gem 'factory_girl_rails'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :development, :production do
  gem 'simple_postmark'
  gem 'mail_safe', git: 'git://github.com/davekaro/mail_safe.git'
end

gem 'jquery-rails'
gem 'bootstrap-sass', '~> 2.0.3'
gem 'simple_form'
gem 'chronic'
gem 'devise'
gem 'cancan'
gem 'annotate', '>=2.5.0.pre1'
gem 'debugger'

