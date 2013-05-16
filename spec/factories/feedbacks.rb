# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feedback do
    code "MyString"
    score "MyText"
    comment "MyText"
    will_recommend false
    completed false
    points 1
    user nil
    outlet nil
  end
end
