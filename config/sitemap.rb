SitemapGenerator::Sitemap.default_host = ENV.fetch("APP_HOST", "https://cineverse.fr")

SitemapGenerator::Sitemap.create do
  add about_path, changefreq: "monthly"
  add contact_path, changefreq: "monthly"
  add faq_path, changefreq: "monthly"
  add now_playing_path, changefreq: "daily"
  add upcoming_movies_path, changefreq: "daily"
  add trending_path, changefreq: "daily"
  add deals_path, changefreq: "daily"

  Movie.find_each do |movie|
    add movie_path(movie), lastmod: movie.updated_at, changefreq: "weekly"
  end

  CastMember.find_each do |cast_member|
    add cast_member_path(cast_member), changefreq: "monthly"
  end
end
