FactoryBot.define do
  factory :user do
    username {"Pekka"}
    password {"Foobar1*"}
    password_confirmation {"Foobar1*"}
  end

  factory :brewery do
    name {"anonymous"}
    year { 1900 }
    active {true}
  end

  factory :style do
    name {"IPA"}
    description {"India Pale Ale style"}
  end

  factory :beer do
    name {"anonymous"}
    style
    brewery #is created with brewery factory
  end

  factory :rating do
    score {10}
    beer
    user
  end
end
