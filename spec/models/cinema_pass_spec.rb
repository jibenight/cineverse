require 'rails_helper'

RSpec.describe CinemaPass, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:pass_type) }

    it "requires provider_custom_name when provider is other" do
      pass = build(:cinema_pass, :other_provider, provider_custom_name: nil)
      expect(pass).not_to be_valid
    end

    it "does not require provider_custom_name for standard providers" do
      pass = build(:cinema_pass, provider: :ugc_illimite, provider_custom_name: nil)
      expect(pass).to be_valid
    end
  end

  describe "enums" do
    it {
      is_expected.to define_enum_for(:provider).with_values(
        ugc_illimite: 0, pathe_gaumont_cinepass: 1, mk2_illimite: 2,
        cinepass_independant: 3, other: 4
      )
    }
    it { is_expected.to define_enum_for(:pass_type).with_values(solo: 0, duo: 1, famille: 2) }
  end

  describe "scopes" do
    it ".active returns non-expired passes" do
      active = create(:cinema_pass, expiration_date: 1.month.from_now)
      expired = create(:cinema_pass, :expired)
      expect(CinemaPass.active).to include(active)
      expect(CinemaPass.active).not_to include(expired)
    end

    it ".expiring_soon returns passes expiring within 30 days" do
      expiring = create(:cinema_pass, :expiring_soon)
      far_away = create(:cinema_pass, expiration_date: 6.months.from_now)
      expect(CinemaPass.expiring_soon).to include(expiring)
      expect(CinemaPass.expiring_soon).not_to include(far_away)
    end

    it ".visible returns passes with display_on_profile true" do
      visible = create(:cinema_pass, display_on_profile: true)
      hidden = create(:cinema_pass, display_on_profile: false)
      expect(CinemaPass.visible).to include(visible)
      expect(CinemaPass.visible).not_to include(hidden)
    end
  end

  describe "#display_name" do
    it "returns custom name for other provider" do
      pass = build(:cinema_pass, :other_provider)
      expect(pass.display_name).to eq("Mon Ciné Local")
    end

    it "returns formatted provider name for standard providers" do
      pass = build(:cinema_pass, provider: :ugc_illimite)
      expect(pass.display_name).to be_a(String)
      expect(pass.display_name).not_to be_empty
    end
  end

  describe "#can_invite?" do
    it "returns true for duo pass" do
      expect(build(:cinema_pass, :duo).can_invite?).to be true
    end

    it "returns true for famille pass" do
      expect(build(:cinema_pass, :famille).can_invite?).to be true
    end

    it "returns false for solo pass" do
      expect(build(:cinema_pass, pass_type: :solo).can_invite?).to be false
    end
  end

  describe "#expiring_soon?" do
    it "returns true when expiration within 30 days" do
      pass = build(:cinema_pass, :expiring_soon)
      expect(pass.expiring_soon?).to be true
    end

    it "returns false when expiration far away" do
      pass = build(:cinema_pass, expiration_date: 6.months.from_now)
      expect(pass.expiring_soon?).to be false
    end

    it "returns false when no expiration_date" do
      pass = build(:cinema_pass, expiration_date: nil)
      expect(pass.expiring_soon?).to be false
    end
  end
end
