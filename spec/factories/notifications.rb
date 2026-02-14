FactoryBot.define do
  factory :notification do
    user
    association :notifiable, factory: :follow
    action { :new_follower }
    read { false }
  end
end
