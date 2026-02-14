require 'rails_helper'

RSpec.describe AdminDailyStat, type: :model do
  describe "validations" do
    subject { build(:admin_daily_stat) }

    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_uniqueness_of(:date) }
  end

  describe "scopes" do
    let!(:recent_stat) { create(:admin_daily_stat, date: 5.days.ago.to_date) }
    let!(:old_stat) { create(:admin_daily_stat, date: 60.days.ago.to_date) }

    it ".recent returns stats from last N days" do
      expect(AdminDailyStat.recent(30)).to include(recent_stat)
      expect(AdminDailyStat.recent(30)).not_to include(old_stat)
    end

    it ".for_period returns stats in date range" do
      expect(AdminDailyStat.for_period(10.days.ago.to_date, Date.current)).to include(recent_stat)
      expect(AdminDailyStat.for_period(10.days.ago.to_date, Date.current)).not_to include(old_stat)
    end
  end
end
