FactoryBot.define do
  factory :user do
    name { "John Doe" }
    email { Faker::Internet.unique.email }
    password { "SecurePass1!" }
    password_confirmation { "SecurePass1!" }
  end
end
