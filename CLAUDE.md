# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

CinéVerse is a French-language cinema social platform built with Ruby on Rails 7.2, Ruby 3.4.8 (rbenv), PostgreSQL, Redis, and Sidekiq. It combines movie discovery (TMDb API), social features (follows, messaging, ratings), ticketing (affiliate links, cinema passes), and an admin dashboard.

## Environment Setup

**Critical:** Always initialize rbenv before running any Ruby/Rails command:
```bash
eval "$(rbenv init -)"
```

## Common Commands

```bash
# Start dev server (web + JS + CSS watchers)
bin/dev

# Run full test suite (367 specs)
eval "$(rbenv init -)" && bundle exec rspec

# Run specific test file or line
bundle exec rspec spec/models/user_spec.rb
bundle exec rspec spec/requests/movies_spec.rb:49

# Run test categories
bundle exec rspec spec/models/        # 237 model specs
bundle exec rspec spec/services/      # 30 service specs
bundle exec rspec spec/policies/      # 54 policy specs
bundle exec rspec spec/requests/      # 46 request specs

# Linting
bundle exec rubocop
bundle exec rubocop -a               # auto-fix

# Security scan
bundle exec brakeman

# Database
bundle exec rails db:migrate
bundle exec rails db:migrate RAILS_ENV=test

# Check route names (important for admin nested routes)
bundle exec rails routes | grep <pattern>
```

## Architecture

### Authorization Pattern (Pundit)
`ApplicationController` enforces Pundit on every action:
- `after_action :verify_authorized, except: :index` — every non-index action must call `authorize`
- `after_action :verify_policy_scoped, only: :index` — index actions must use `policy_scope`
- Controllers that skip these must use `raise: false` to avoid Rails 7.1 callback strictness errors when the controller lacks an `index` or other referenced action

### Locale
All user-facing text is French. Default locale is `:fr`, set in `ApplicationController#set_locale`. Translations live in `config/locales/fr.yml`.

### Routing Conventions
- User profiles use `:username` param: `/profile/:username`
- Admin namespace routes get double-prefixed member actions (e.g., `promote_admin_admin_user_path`, not `promote_admin_user_path`). Always verify with `rails routes | grep`.
- Admin user actions (ban, unban, promote) are `POST`, not `PATCH`

### Key Layers
- **Models** (34): Core domain with enums, scopes, callbacks. User roles: `user`, `premium`, `admin`. Movie statuses: `now_playing`, `upcoming`, `released`.
- **Policies** (11 in `app/policies/`): Pundit policies. Base `ApplicationPolicy` provides admin/owner checks.
- **Services** (5 in `app/services/`): `TmdbSyncService`, `BadgeCheckerService`, `SpamDetectionService`, `AffiliateLinkService`, `NewsletterSendService`.
- **ViewComponents** (15 in `app/components/`): Reusable UI components (MovieCard, UserAvatar, RatingStars, etc.).
- **Jobs** (9 in `app/jobs/`): Sidekiq background jobs. Queues: `critical`, `default`, `low`, `mailers`. Cron schedules in `config/sidekiq_cron.yml`.
- **Channels** (3): ActionCable for live messaging (`ConversationChannel`), notifications (`NotificationsChannel`), and presence (`AppearanceChannel`).

### Frontend
Hotwire stack: Turbo Drive/Frames/Streams + Stimulus.js controllers (in `app/javascript/controllers/`). TailwindCSS for styling with dark/light mode support.

## Testing Gotchas

- **`allow_browser versions: :modern`**: Returns 406/404 in request specs without a proper User-Agent header. Add a Chrome UA header when testing unauthenticated GET requests that hit this middleware.
- **Asset pipeline in test**: Empty files must exist at `app/assets/builds/application.css`, `app/assets/builds/application.js`, and `app/assets/builds/chartkick.js`.
- **Shoulda matchers + enum columns**: Uniqueness validations on enum-backed columns can produce false failures. Use manual duplicate-record tests instead.
- **Devise in request specs**: Include `sign_in user` from `Devise::Test::IntegrationHelpers` (already configured in `rails_helper.rb`).
- **Factories**: Complete set in `spec/factories/` for all 31+ models. Use FactoryBot `create`/`build` syntax (included globally).
