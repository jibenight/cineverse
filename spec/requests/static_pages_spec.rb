require 'rails_helper'

RSpec.describe "Static Pages", type: :request do
  before do
    %w[about contact faq privacy terms].each do |slug|
      create(:static_page, slug: slug, title: slug.capitalize, body_html: "<p>#{slug} content</p>")
    end
  end

  %w[about contact faq privacy terms].each do |page|
    describe "GET /#{page}" do
      it "returns success" do
        get "/#{page}"
        expect(response).to have_http_status(:success)
      end
    end
  end
end
