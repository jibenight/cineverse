require 'rails_helper'

RSpec.describe "Deals", type: :request do
  describe "GET /deals" do
    before do
      user = create(:user, city: "Paris")
      create(:user_discount, user: user, shareable: true)
    end

    it "returns success" do
      get deals_path
      expect(response).to have_http_status(:success)
    end
  end
end
