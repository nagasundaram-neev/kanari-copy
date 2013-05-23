# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :outlet do
    name "MyString"
    address "MyText"
    geolocation "MyText"
    website_url "MyString"
    email "MyString"
    points 1
    phone_number "MyString"
    open_hours "MyString"
    has_delivery false
    serves_alcohol false
    has_outdoor_seating false
    customer nil
  end
end
