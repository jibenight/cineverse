# CinéVerse

Plateforme sociale de cinéma construite avec Ruby on Rails. Découvrez des films, partagez vos critiques, échangez avec d'autres cinéphiles et profitez de bons plans pour vos sorties ciné.

## Stack technique

- **Backend :** Ruby 3.4.8, Rails 8.1, PostgreSQL
- **Frontend :** Hotwire (Turbo + Stimulus), TailwindCSS, esbuild
- **Temps réel :** ActionCable + Redis
- **Jobs :** Sidekiq + sidekiq-cron
- **Auth :** Devise 5.0 (+ 2FA pour admins)
- **Autorisations :** Pundit
- **API externe :** TMDb (The Movie Database)

## Prérequis

- Ruby 3.4.8 (via [rbenv](https://github.com/rbenv/rbenv))
- Node.js 20.x + npm
- PostgreSQL 14+
- Redis 7+

## Installation

```bash
# Cloner le projet
git clone <repo-url> && cd cineverse

# Installer les dépendances
bundle install
npm install

# Configurer les variables d'environnement
cp .env.example .env
# Renseigner TMDB_API_KEY, REDIS_URL, etc.

# Créer et migrer la base de données
bin/rails db:create db:migrate db:seed
```

Le seed crée un compte admin (`admin@cineverse.fr` / `password123456`), 10 utilisateurs, des films, genres, badges et pages statiques.

## Lancer le projet

```bash
# Serveur de développement (Rails + watchers JS/CSS)
bin/dev

# Ou séparément
bin/rails server
npm run build -- --watch
npm run build:css -- --watch
```

L'application est accessible sur `http://localhost:3000`.

### Sidekiq

```bash
bundle exec sidekiq
```

Interface web Sidekiq disponible sur `/admin/sidekiq` (accès admin requis).

## Tests

```bash
# Suite complète (366 specs)
bundle exec rspec

# Par catégorie
bundle exec rspec spec/models/        # Specs modèles
bundle exec rspec spec/services/      # Specs services
bundle exec rspec spec/policies/      # Specs policies
bundle exec rspec spec/requests/      # Specs requêtes

# Fichier ou ligne spécifique
bundle exec rspec spec/models/user_spec.rb
bundle exec rspec spec/requests/movies_spec.rb:49
```

## Linting

```bash
bundle exec rubocop          # Vérification
bundle exec rubocop -a        # Auto-correction
bundle exec brakeman          # Analyse de sécurité
```

## Fonctionnalités

### Films
- Catalogue avec données TMDb (synchronisation automatique toutes les 6h, région France)
- Pages "En salle", "Prochainement", "Tendances", calendrier des sorties
- Recherche locale avec fallback TMDb et import automatique
- Système de notes (0.5 - 5 étoiles) avec critiques et spoilers
- Watchlist personnelle avec réorganisation drag & drop
- Alertes de sortie

### Social
- Profils utilisateurs (`/profile/:username`)
- Système de suivi (follow/unfollow)
- Messagerie privée en temps réel (ActionCable)
- Notifications en temps réel
- Système de badges et récompenses (11 badges)
- Signalement de contenu

### Billetterie & Bons plans
- Liens affiliés vers les cinémas partenaires (Pathé Gaumont, UGC, MK2, CGR, Kinepolis)
- Gestion de pass cinéma (Pathé Gaumont Illimité, UGC Illimité, etc.)
- Partage de réductions entre utilisateurs

### Newsletter
- Double opt-in (RGPD)
- Campagnes avec suivi d'ouvertures et de clics
- Préférences de contenu par abonné
- Envoi hebdomadaire automatique (dimanche 10h)

### Administration (`/admin`)
- Dashboard avec KPIs et graphiques (Chartkick)
- Gestion des utilisateurs (ban, promotion admin/premium, export CSV)
- Modération (signalements, mutes, suppression de contenu)
- Gestion du contenu (films, pages statiques, sync TMDb)
- Gestion de la newsletter (campagnes, abonnés, templates)
- Suivi des affiliés
- Logs d'audit et monitoring système

## Structure du projet

```
app/
├── channels/          # ActionCable (chat, notifications, présence)
├── components/        # ViewComponents (MovieCard, RatingStars, etc.)
├── controllers/       # Controllers + namespace admin/
├── jobs/              # Sidekiq jobs (TMDb sync, alertes, stats, etc.)
├── mailers/           # ContactMailer, NewsletterMailer
├── models/            # 34 modèles ActiveRecord
├── policies/          # 11 policies Pundit
├── services/          # TmdbSync, BadgeChecker, SpamDetection, etc.
└── views/             # Templates ERB + layouts admin

spec/
├── factories/         # FactoryBot (toutes les factories)
├── models/            # Specs unitaires modèles
├── policies/          # Specs policies Pundit
├── services/          # Specs services
└── requests/          # Specs d'intégration HTTP
```

## Tâches planifiées (Cron)

| Tâche | Fréquence | Description |
|-------|-----------|-------------|
| TMDb Sync | Toutes les 6h | Synchronisation des données films |
| Alertes sorties | Tous les jours 8h | Notifications de sorties |
| Stats quotidiennes | Tous les jours 3h | Agrégation des statistiques |
| Sitemap | Tous les jours 4h | Régénération du sitemap |
| Newsletter hebdo | Dimanche 10h | Envoi de la newsletter |
| Backup BDD | Tous les jours 2h | Sauvegarde PostgreSQL |
| Expiration pass | Tous les jours 9h | Alertes d'expiration des pass |

## Déploiement

Un `Dockerfile` multi-stage est fourni pour le déploiement en production :

```bash
docker build -t cineverse .
docker run -p 3000:3000 -e RAILS_MASTER_KEY=<key> cineverse
```

Les migrations sont exécutées automatiquement au démarrage du conteneur.

## Variables d'environnement

| Variable | Description |
|----------|-------------|
| `TMDB_API_KEY` | Clé API The Movie Database |
| `REDIS_URL` | URL de connexion Redis |
| `SENTRY_DSN` | DSN Sentry (optionnel) |
| `APP_HOST` | URL de l'application |
| `SECRET_KEY_BASE` | Clé secrète Rails |
| `CINEVERSE_DATABASE_PASSWORD` | Mot de passe BDD (production) |

## Licence

Tous droits réservés.
