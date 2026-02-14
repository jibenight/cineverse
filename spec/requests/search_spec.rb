require 'rails_helper'

RSpec.describe "Search", type: :request do
  describe "GET /search" do
    before do
      create(:movie, title: "Inception")
      create(:movie, title: "Interstellar")
    end

    it "returns success" do
      get search_path, params: { q: "Inception" }
      expect(response).to have_http_status(:success)
    end

    it "returns results without query" do
      get search_path
      expect(response).to have_http_status(:success)
    end
  end
end
