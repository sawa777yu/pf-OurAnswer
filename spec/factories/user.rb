FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    our_answers_id { 'test' }
    email { 'test@example.com' }
    password { 'password' }
  end
end