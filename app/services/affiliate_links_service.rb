class AffiliateLinksService
  def initialize
    @config = YAML.load_file(Rails.root.join("config", "affiliates.yml"))["providers"]
  end

  def links_for(movie, user: nil)
    return [] unless movie.now_playing?

    @config.map do |key, provider|
      user_pass = user&.cinema_passes&.find { |p| pass_matches_provider?(p, key) }
      slug = movie.title.parameterize

      {
        provider_key: key,
        name: provider["name"],
        logo: provider["logo"],
        url: build_url(provider, slug),
        has_pass: user_pass.present?,
        can_invite: user_pass&.can_invite?,
        estimated_cpc: provider["estimated_cpc"]
      }
    end
  end

  private

  def build_url(provider, slug)
    "#{provider['base_url']}#{slug}?#{provider['affiliate_param']}"
  end

  def pass_matches_provider?(pass, provider_key)
    mapping = {
      "pathe_gaumont" => "pathe_gaumont_cinepass",
      "ugc" => "ugc_illimite",
      "mk2" => "mk2_illimite"
    }
    pass.provider == mapping[provider_key]
  end
end
