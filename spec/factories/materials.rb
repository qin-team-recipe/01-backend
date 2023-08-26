FactoryBot.define do
  factory :material do
    name { Faker::Food.ingredient }
    position { 1 } # デフォルトでは1を設定する。2以降は指定する。
  end
end
