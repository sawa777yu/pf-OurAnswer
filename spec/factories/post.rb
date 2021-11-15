FactoryBot.define do
  factory:post do
    reference_url { Faker::Internet.url }
    genre
    title { Faker::Lorem.characters(number:5) }
    body { Faker::Lorem.characters(number:15) }
    user
  end
end