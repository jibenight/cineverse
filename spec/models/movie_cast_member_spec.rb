require 'rails_helper'

RSpec.describe MovieCastMember, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:movie) }
    it { is_expected.to belong_to(:cast_member) }
  end

  describe "scopes" do
    it ".ordered returns members by order field" do
      movie = create(:movie)
      cm1 = create(:cast_member)
      cm2 = create(:cast_member)
      mcm2 = MovieCastMember.create!(movie: movie, cast_member: cm2, character: "B", order: 2)
      mcm1 = MovieCastMember.create!(movie: movie, cast_member: cm1, character: "A", order: 1)
      expect(MovieCastMember.ordered.first).to eq(mcm1)
    end
  end
end
