FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.name }
    last_name { Faker::Internet.user_name }
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"
  end

  factory :kingdom do
    name {Faker::Lorem.word + Faker::Lorem.word + Faker::Lorem.word}
  end

  factory :phylum do
    name {Faker::Lorem.word + Faker::Lorem.word + Faker::Lorem.word}
    kingdom_id {rand(1..3)}
  end

  factory :chlass do
    name {Faker::Lorem.word + Faker::Lorem.word + Faker::Lorem.word}
    phylum_id {rand(1..3)}
  end

  factory :order do
    name {Faker::Lorem.word + Faker::Lorem.word + Faker::Lorem.word}
    chlass_id {rand(1..3)}
  end

  factory :family do
    name {Faker::Lorem.word + Faker::Lorem.word + Faker::Lorem.word}
    order_id {rand(1..3)}
  end

  factory :genus do
    name {Faker::Lorem.word + Faker::Lorem.word + Faker::Lorem.word}
    family_id {rand(1..3)}
  end

  factory :species do
    common_name {Faker::Lorem.word + Faker::Lorem.word + Faker::Lorem.word}
    scientific_name {Faker::Lorem.word + Faker::Lorem.word + Faker::Lorem.word}
    red_list_status {Faker::Lorem.word + Faker::Lorem.word + Faker::Lorem.word}
    population_trend {Faker::Lorem.word + Faker::Lorem.word + Faker::Lorem.word}
    genus_id {rand(1..3)}
  end
end