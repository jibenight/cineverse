puts "Seeding CinéVerse database..."

# Create admin user
admin = User.find_or_create_by!(email: "admin@cineverse.fr") do |u|
  u.username = "admin"
  u.password = "password123"
  u.password_confirmation = "password123"
  u.role = :admin
  u.theme_preference = :dark
  u.city = "Paris"
  u.bio = "Administrateur CinéVerse"
  u.confirmed_at = Time.current
end
puts "Admin created: #{admin.email}"

# Create sample users
users = []
10.times do |i|
  user = User.find_or_create_by!(email: "user#{i + 1}@cineverse.fr") do |u|
    u.username = "cinephile#{i + 1}"
    u.password = "password123"
    u.password_confirmation = "password123"
    u.role = i == 0 ? :premium : :user
    u.theme_preference = %i[dark light].sample
    u.city = %w[Paris Lyon Marseille Bordeaux Toulouse Lille Nantes Strasbourg Montpellier Nice].sample
    u.bio = "Passionné de cinéma depuis toujours !"
    u.confirmed_at = Time.current
    u.notifications_enabled = true
  end
  users << user
end
puts "#{users.count} sample users created"

# Create badges
badges_data = [
  { slug: "cinephile_debutant", name: "Cinéphile débutant", description: "A noté 10 films", icon: "🎬", category: :watching, condition_type: "movies_rated", condition_value: 10 },
  { slug: "cinephile_confirme", name: "Cinéphile confirmé", description: "A noté 50 films", icon: "🎬", category: :watching, condition_type: "movies_rated", condition_value: 50 },
  { slug: "cinephile_expert", name: "Cinéphile expert", description: "A noté 100 films", icon: "🎬", category: :watching, condition_type: "movies_rated", condition_value: 100 },
  { slug: "premiere_critique", name: "Première critique", description: "A écrit sa première critique", icon: "✍️", category: :watching, condition_type: "reviews_written", condition_value: 1 },
  { slug: "critique_prolifique", name: "Critique prolifique", description: "A écrit 25 critiques", icon: "✍️", category: :watching, condition_type: "reviews_written", condition_value: 25 },
  { slug: "aime_communaute", name: "Aimé par la communauté", description: "50 likes reçus sur ses critiques", icon: "❤️", category: :community, condition_type: "likes_received", condition_value: 50 },
  { slug: "sociable", name: "Sociable", description: "10 abonnés", icon: "👥", category: :social, condition_type: "followers_count", condition_value: 10 },
  { slug: "influenceur_cine", name: "Influenceur ciné", description: "100 abonnés", icon: "👥", category: :social, condition_type: "followers_count", condition_value: 100 },
  { slug: "membre_fidele", name: "Membre fidèle", description: "Inscrit depuis 1 an", icon: "🗓️", category: :loyalty, condition_type: "account_age_days", condition_value: 365 },
  { slug: "noctambule", name: "Noctambule", description: "A noté un film entre minuit et 5h du matin", icon: "🌙", category: :watching, condition_type: "night_rating", condition_value: 1 },
  { slug: "binge_watcher", name: "Binge watcher", description: "5 films notés en une journée", icon: "📺", category: :watching, condition_type: "daily_ratings", condition_value: 5 }
]

badges_data.each do |data|
  Badge.find_or_create_by!(slug: data[:slug]) do |b|
    b.assign_attributes(data)
  end
end
puts "#{badges_data.count} badges created"

# Create genres
genres_data = [
  { tmdb_id: 28, name: "Action" },
  { tmdb_id: 12, name: "Aventure" },
  { tmdb_id: 16, name: "Animation" },
  { tmdb_id: 35, name: "Comédie" },
  { tmdb_id: 80, name: "Crime" },
  { tmdb_id: 99, name: "Documentaire" },
  { tmdb_id: 18, name: "Drame" },
  { tmdb_id: 10751, name: "Familial" },
  { tmdb_id: 14, name: "Fantastique" },
  { tmdb_id: 36, name: "Histoire" },
  { tmdb_id: 27, name: "Horreur" },
  { tmdb_id: 10402, name: "Musique" },
  { tmdb_id: 9648, name: "Mystère" },
  { tmdb_id: 10749, name: "Romance" },
  { tmdb_id: 878, name: "Science-Fiction" },
  { tmdb_id: 53, name: "Thriller" },
  { tmdb_id: 10752, name: "Guerre" },
  { tmdb_id: 37, name: "Western" }
]

genres_data.each do |data|
  Genre.find_or_create_by!(tmdb_id: data[:tmdb_id]) do |g|
    g.name = data[:name]
  end
end
puts "#{genres_data.count} genres created"

# Create sample movies
movies_data = [
  { tmdb_id: 1, title: "Gladiator II", overview: "Des années après avoir assisté à la mort du héros vénéré Maximus aux mains de son oncle, Lucius est contraint d'entrer dans le Colisée.", poster_path: nil, release_date: Date.new(2024, 11, 13), runtime: 148, status: :now_playing, popularity: 95.0, vote_average: 4.1 },
  { tmdb_id: 2, title: "Wicked", overview: "L'histoire inédite des sorcières du Pays d'Oz.", poster_path: nil, release_date: Date.new(2024, 11, 27), runtime: 160, status: :now_playing, popularity: 88.0, vote_average: 4.3 },
  { tmdb_id: 3, title: "Moana 2", overview: "Moana se lance dans un nouveau voyage épique.", poster_path: nil, release_date: Date.new(2024, 11, 27), runtime: 100, status: :now_playing, popularity: 82.0, vote_average: 3.8 },
  { tmdb_id: 4, title: "The Last Breath", overview: "Un thriller sous-marin terrifiant.", poster_path: nil, release_date: Date.new(2025, 3, 15), runtime: 110, status: :upcoming, popularity: 45.0, vote_average: 0.0 },
  { tmdb_id: 5, title: "Thunderbolts*", overview: "Un groupe d'anti-héros Marvel.", poster_path: nil, release_date: Date.new(2025, 5, 2), runtime: 135, status: :upcoming, popularity: 72.0, vote_average: 0.0 },
]

movies_data.each do |data|
  Movie.find_or_create_by!(tmdb_id: data[:tmdb_id]) do |m|
    m.assign_attributes(data)
  end
end
puts "#{movies_data.count} sample movies created"

# Add genres to movies
Movie.all.each do |movie|
  genres = Genre.order("RANDOM()").limit(rand(1..3))
  movie.genres = genres
end
puts "Genres assigned to movies"

# Create some ratings
Movie.where(status: :now_playing).each do |movie|
  users.sample(rand(3..8)).each do |user|
    Rating.find_or_create_by!(user: user, movie: movie) do |r|
      r.score = (rand(1..10) / 2.0).round(1)
      r.score = [r.score, 0.5].max
      r.score = [r.score, 5.0].min
      r.review_text = ["Super film !", "Bof, pas terrible...", "Un chef-d'oeuvre !", "Correct, sans plus.", "À voir absolument !", nil].sample
      r.spoiler = false
    end
  end
end
puts "Ratings created"

# Create some follows
users.each do |user|
  users.sample(rand(1..4)).each do |other|
    next if user == other
    user.follow(other) rescue nil
  end
end
puts "Follows created"

# Create static pages
[
  { slug: "about", title: "À propos de CinéVerse", body_html: "<h2>CinéVerse</h2><p>CinéVerse est la plateforme sociale dédiée aux passionnés de cinéma. Découvrez des films, partagez vos critiques, échangez avec d'autres cinéphiles et profitez de bons plans pour vos sorties ciné.</p>" },
  { slug: "contact", title: "Contact", body_html: "<h2>Contactez-nous</h2><p>Vous avez une question ou une suggestion ? Contactez-nous à hello@cineverse.fr</p>" },
  { slug: "faq", title: "FAQ", body_html: "<h2>Questions Fréquentes</h2><h3>Comment noter un film ?</h3><p>Rendez-vous sur la fiche du film et cliquez sur les étoiles pour attribuer votre note.</p><h3>Comment ajouter mon pass cinéma ?</h3><p>Allez dans Paramètres > Pass Cinéma et remplissez les informations de votre abonnement.</p>" },
  { slug: "privacy", title: "Politique de Confidentialité", body_html: "<h2>Politique de Confidentialité</h2><p>CinéVerse s'engage à protéger vos données personnelles conformément au RGPD. Vos données sont collectées avec votre consentement explicite et ne sont jamais vendues à des tiers.</p><h3>Données collectées</h3><p>Email, nom d'utilisateur, préférences de notification, historique de navigation cinéma.</p><h3>Vos droits</h3><p>Vous pouvez demander l'accès, la rectification ou la suppression de vos données à tout moment.</p>" },
  { slug: "terms", title: "Conditions Générales d'Utilisation", body_html: "<h2>CGU CinéVerse</h2><p>En utilisant CinéVerse, vous acceptez les présentes conditions d'utilisation.</p><h3>Utilisation du service</h3><p>CinéVerse est un service gratuit de partage d'avis sur le cinéma. L'inscription est gratuite.</p><h3>Contenus</h3><p>Les critiques publiées engagent la responsabilité de leurs auteurs. Tout contenu illicite sera supprimé.</p>" }
].each do |data|
  StaticPage.find_or_create_by!(slug: data[:slug]) do |p|
    p.assign_attributes(data)
  end
end
puts "Static pages created"

puts "Seeding complete!"
