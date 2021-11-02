User.create!(
  [
    {
      name: '銘苅一基',
      our_answers_id: 'mekari',
      email: 'mekari@test.com',
      password: 'mekari'
    },
    {
      name: '清丸国秀',
      our_answers_id: 'kiyomaru',
      email: 'kiyomaru@test.com',
      password: 'kiyomaru'
    },
    {
      name: '白岩篤子',
      our_answers_id: 'shiraiwa',
      email: 'shiraiwa@test.com',
      password: 'shiraiwa'
    },
    {
      name: '高木藤丸',
      our_answers_id: 'takagi',
      email: 'takagi@test.com',
      password: 'takagi'
    },
    {
      name: '九条音弥',
      our_answers_id: 'kujo',
      email: 'kujo@test.com',
      password: 'kujootoya'
    }
  ]
)

30.times do |n|
  User.create!(
    name: "テスト太郎#{n + 1}",
    our_answers_id: "test#{n + 1}",
    email: "test#{n + 1}@test.com",
    password: "test#{n + 1}#{n + 1}"
  )
end
