class StaticPage < ApplicationRecord
  enum :slug, { about: "about", contact: "contact", faq: "faq", privacy: "privacy", terms: "terms" }

  validates :slug, presence: true, uniqueness: true
  validates :title, presence: true
  validates :body_html, presence: true
end
