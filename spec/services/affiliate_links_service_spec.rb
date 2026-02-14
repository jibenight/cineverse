require 'rails_helper'

RSpec.describe AffiliateLinksService do
  let(:service) { described_class.new }

  describe "#links_for" do
    let(:now_playing_movie) { create(:movie, title: "Mon Super Film", status: :now_playing) }
    let(:upcoming_movie) { create(:movie, :upcoming) }

    it "returns affiliate links for now_playing movies" do
      links = service.links_for(now_playing_movie)
      expect(links).not_to be_empty
      expect(links.first).to include(:provider_key, :name, :url, :has_pass)
    end

    it "returns empty array for upcoming movies" do
      links = service.links_for(upcoming_movie)
      expect(links).to be_empty
    end

    it "includes provider name and URL" do
      links = service.links_for(now_playing_movie)
      link = links.first
      expect(link[:name]).to be_a(String)
      expect(link[:url]).to include("mon-super-film")
    end

    context "with user having a cinema pass" do
      let(:user) { create(:user) }

      it "marks has_pass true when user has matching pass" do
        create(:cinema_pass, user: user, provider: :ugc_illimite)
        links = service.links_for(now_playing_movie, user: user)
        ugc_link = links.find { |l| l[:provider_key] == "ugc" }
        expect(ugc_link[:has_pass]).to be true
      end

      it "marks has_pass false when user has no matching pass" do
        links = service.links_for(now_playing_movie, user: user)
        expect(links.all? { |l| l[:has_pass] == false }).to be true
      end

      it "marks can_invite true for duo pass" do
        create(:cinema_pass, user: user, provider: :ugc_illimite, pass_type: :duo)
        links = service.links_for(now_playing_movie, user: user)
        ugc_link = links.find { |l| l[:provider_key] == "ugc" }
        expect(ugc_link[:can_invite]).to be true
      end
    end
  end
end
