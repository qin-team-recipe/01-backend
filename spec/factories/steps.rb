FactoryBot.define do
  factory :step do
    description { Faker::Lorem.sentence(word_count: 25) }
    position { 1 } # デフォルトでは1を設定する。2以降は指定する。
  end
end
