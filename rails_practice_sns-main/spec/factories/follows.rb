FactoryBot.define do
  factory :follow do
    follow_user_id { 1 }
    followed_user_id { 1 }
  end
end
