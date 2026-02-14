require 'rails_helper'

RSpec.describe BadgeCheckerService do
  let(:user) { create(:user) }
  let(:service) { described_class.new(user) }

  before do
    create(:badge, :cinephile_debutant)
    create(:badge, :premiere_critique)
    create(:badge, :noctambule)
  end

  describe "#check_all" do
    context "movies_rated badges" do
      it "awards 'cinephile_debutant' badge after 10 rated movies" do
        10.times { create(:rating, user: user) }
        newly_earned = service.check_all
        expect(newly_earned.map(&:slug)).to include("cinephile_debutant")
      end

      it "does not award badge if condition not met" do
        5.times { create(:rating, user: user) }
        newly_earned = service.check_all
        expect(newly_earned.map(&:slug)).not_to include("cinephile_debutant")
      end

      it "does not re-award already earned badges" do
        10.times { create(:rating, user: user) }
        service.check_all
        newly_earned = service.check_all
        expect(newly_earned).to be_empty
      end
    end

    context "reviews_written badges" do
      it "awards 'premiere_critique' badge after 1 review" do
        create(:rating, :with_review, user: user)
        newly_earned = service.check_all
        expect(newly_earned.map(&:slug)).to include("premiere_critique")
      end

      it "does not count ratings without review text" do
        create(:rating, user: user, review_text: nil)
        newly_earned = service.check_all
        expect(newly_earned.map(&:slug)).not_to include("premiere_critique")
      end
    end

    context "night_rating badges" do
      it "awards 'noctambule' badge for night-time rating" do
        create(:rating, user: user, created_at: Time.current.change(hour: 2))
        newly_earned = service.check_all
        expect(newly_earned.map(&:slug)).to include("noctambule")
      end
    end

    it "creates UserBadge records" do
      10.times { create(:rating, user: user) }
      expect { service.check_all }.to change(UserBadge, :count).by_at_least(1)
    end

    it "creates notifications for new badges" do
      10.times { create(:rating, user: user) }
      expect { service.check_all }.to change(Notification, :count).by_at_least(1)
    end
  end
end
