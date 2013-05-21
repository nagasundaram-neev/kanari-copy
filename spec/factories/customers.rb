# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :customer do
    name "MyString"
    phone_number "MyString"
    registered_address "MyText"
    mailing_address "MyText"
  end
end
