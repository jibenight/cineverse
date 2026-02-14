class CinemaPass < ApplicationRecord
  belongs_to :user

  enum :provider, {
    ugc_illimite: 0,
    pathe_gaumont_cinepass: 1,
    mk2_illimite: 2,
    cinepass_independant: 3,
    other: 4
  }
  enum :pass_type, { solo: 0, duo: 1, famille: 2 }

  validates :provider, presence: true
  validates :pass_type, presence: true
  validates :provider_custom_name, presence: true, if: -> { other? }

  scope :active, -> { where("expiration_date IS NULL OR expiration_date > ?", Date.current) }
  scope :expiring_soon, -> { where("expiration_date <= ?", 30.days.from_now).where("expiration_date > ?", Date.current) }
  scope :visible, -> { where(display_on_profile: true) }

  def display_name
    other? ? provider_custom_name : provider.titleize.gsub("_", " ")
  end

  def can_invite?
    duo? || famille?
  end

  def expiring_soon?
    expiration_date.present? && expiration_date <= 30.days.from_now && expiration_date > Date.current
  end
end
