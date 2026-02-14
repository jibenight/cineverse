require 'rails_helper'

RSpec.describe StaticPage, type: :model do
  describe "validations" do
    subject { build(:static_page) }

    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body_html) }
  end
end
