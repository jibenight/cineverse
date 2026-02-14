require 'rails_helper'

RSpec.describe "Movies", type: :request do
  let(:user) { create(:user) }

  describe "GET /movies" do
    before { create_list(:movie, 3) }

    it "returns success" do
      get movies_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /movies/:id" do
    let(:movie) { create(:movie) }

    it "returns success" do
      get movie_path(movie)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /now-playing" do
    before { create(:movie, status: :now_playing) }

    it "returns success" do
      get now_playing_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /upcoming" do
    before { create(:movie, :upcoming) }

    it "returns success" do
      get upcoming_movies_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /trending" do
    it "returns success" do
      get trending_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /movies/:id/toggle_watchlist" do
    let(:movie) { create(:movie) }

    context "when authenticated" do
      before { sign_in user }

      it "adds movie to watchlist" do
        expect {
          post toggle_watchlist_movie_path(movie)
        }.to change(WatchlistItem, :count).by(1)
      end

      it "removes movie from watchlist if already added" do
        create(:watchlist_item, user: user, movie: movie)
        expect {
          post toggle_watchlist_movie_path(movie)
        }.to change(WatchlistItem, :count).by(-1)
      end
    end

    context "when not authenticated" do
      it "redirects to sign in" do
        post toggle_watchlist_movie_path(movie)
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe "POST /movies/:id/toggle_release_alert" do
    let(:movie) { create(:movie, :upcoming) }

    before { sign_in user }

    it "creates a release alert" do
      expect {
        post toggle_release_alert_movie_path(movie)
      }.to change(ReleaseAlert, :count).by(1)
    end

    it "removes release alert if already set" do
      create(:release_alert, user: user, movie: movie)
      expect {
        post toggle_release_alert_movie_path(movie)
      }.to change(ReleaseAlert, :count).by(-1)
    end
  end
end
