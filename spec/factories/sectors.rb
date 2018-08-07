FactoryGirl.define do
  factory :sector do
    title { Faker::Lorem.word }

    factory :sector_others do
      title 'Otros'
    end
  end
end
