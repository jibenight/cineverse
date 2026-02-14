require 'rails_helper'

RSpec.describe "Newsletter", type: :request do
  describe "POST /newsletter/subscribe" do
    it "creates a pending subscriber" do
      expect {
        post newsletter_subscribe_path, params: { email: "test@example.com", first_name: "Jean" }
      }.to change(NewsletterSubscriber, :count).by(1)

      subscriber = NewsletterSubscriber.last
      expect(subscriber.status).to eq("pending")
      expect(subscriber.confirmation_token).to be_present
    end

    it "does not create duplicate subscribers" do
      create(:newsletter_subscriber, email: "test@example.com")
      expect {
        post newsletter_subscribe_path, params: { email: "test@example.com" }
      }.not_to change(NewsletterSubscriber, :count)
    end
  end

  describe "GET /newsletter/confirm/:token" do
    let(:subscriber) { create(:newsletter_subscriber, status: :pending) }

    it "confirms the subscriber" do
      get newsletter_confirm_path(subscriber.confirmation_token)
      expect(subscriber.reload.status).to eq("active")
    end
  end

  describe "GET /newsletter/unsubscribe/:token" do
    let(:subscriber) { create(:newsletter_subscriber, :active) }

    it "unsubscribes the subscriber" do
      get newsletter_unsubscribe_path(subscriber.confirmation_token)
      expect(subscriber.reload.status).to eq("unsubscribed")
    end
  end
end
