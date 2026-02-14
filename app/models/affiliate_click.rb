class AffiliateClick < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :movie

  enum :provider, { pathe: 0, ugc: 1, mk2: 2, cgr: 3, kinepolis: 4 }

  validates :provider, presence: true
end
