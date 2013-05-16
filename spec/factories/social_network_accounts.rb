# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :social_network_account do
    access_token "MyString"
    access_secret "MyString"
    refresh_token "MyString"
    provider "MyString"
    user nil
  end
end
