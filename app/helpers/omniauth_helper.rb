module OmniauthHelper
  PROVIDER_CONFIG = {
    google_oauth2: { label: "Google", icon: "shared/icons/google", bg: "bg-white hover:bg-neutral-50 border border-neutral-300 text-neutral-700" },
    github: { label: "GitHub", icon: "shared/icons/github", bg: "bg-[#24292F] hover:bg-[#1b1f23] text-white" },
    apple: { label: "Apple", icon: "shared/icons/apple", bg: "bg-black hover:bg-neutral-900 text-white" }
  }.freeze

  def omniauth_provider_label(provider)
    PROVIDER_CONFIG.dig(provider.to_sym, :label) || provider.to_s.titleize
  end

  def omniauth_provider_icon(provider)
    PROVIDER_CONFIG.dig(provider.to_sym, :icon)
  end

  def omniauth_provider_classes(provider)
    PROVIDER_CONFIG.dig(provider.to_sym, :bg) || "bg-neutral-500 text-white"
  end
end
