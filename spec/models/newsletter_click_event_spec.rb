require 'rails_helper'

RSpec.describe NewsletterClickEvent, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:campaign).class_name("NewsletterCampaign") }
    it { is_expected.to belong_to(:subscriber).class_name("NewsletterSubscriber") }
  end
end
