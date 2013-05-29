# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :outlet do
    name "Outlet1"
    website_url "http://www.outlet1.com"
    email "contact@outlet1.com"
    phone_number "+11239233"
    open_hours "10:00 - 11:00"
    has_delivery true
    serves_alcohol true
    has_outdoor_seating true
    customer nil
  end
end
