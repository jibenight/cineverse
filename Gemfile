source "https://rubygems.org"

ruby "3.4.8"

gem "rails", "~> 7.2.0"
gem "pg", "~> 1.5"
gem "puma", "~> 6.0"
gem "sprockets-rails"
gem "jsbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "cssbundling-rails"
gem "redis", ">= 5.0"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[windows jruby]

# Auth & Authorization
gem "devise", "~> 4.9"
gem "devise-two-factor", "~> 5.0"
gem "pundit", "~> 2.3"

# Background Jobs
gem "sidekiq", "~> 7.2"
gem "sidekiq-cron", "~> 1.12"

# Pagination
gem "pagy", "~> 9.0"

# Security
gem "rack-attack", "~> 6.7"
gem "invisible_captcha", "~> 2.3"

# Monitoring
gem "sentry-ruby", "~> 5.17"
gem "sentry-rails", "~> 5.17"

# UI Components
gem "view_component", "~> 3.12"
gem "chartkick", "~> 5.0"
gem "groupdate", "~> 6.4"

# SEO
gem "sitemap_generator", "~> 6.3"
gem "meta-tags", "~> 2.22"

# Storage
gem "image_processing", "~> 1.13"
gem "aws-sdk-s3", require: false

# Rich Text
gem "actiontext"

# HTTP Client (for TMDb API)
gem "httparty", "~> 0.22"

# Encryption
gem "lockbox", "~> 1.3"

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "rspec-rails", "~> 7.0"
  gem "factory_bot_rails", "~> 6.4"
  gem "faker", "~> 3.3"
  gem "dotenv-rails", "~> 3.1"
  gem "rubocop", "~> 1.62", require: false
  gem "rubocop-rails", "~> 2.24", require: false
  gem "rubocop-rspec", "~> 2.27", require: false
end

group :development do
  gem "web-console"
  gem "letter_opener", "~> 1.10"
  gem "annotate", "~> 3.2"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "shoulda-matchers", "~> 6.2"
  gem "simplecov", require: false
  gem "webmock", "~> 3.23"
end
