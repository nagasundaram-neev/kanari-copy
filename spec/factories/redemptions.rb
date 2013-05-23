# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :redemption do
    user nil
    outlet nil
    points 1
  end
end
