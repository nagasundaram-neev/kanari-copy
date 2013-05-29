# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email "user@kanari.co"
    password "password123"
    password_confirmation "password123"
  end
end
