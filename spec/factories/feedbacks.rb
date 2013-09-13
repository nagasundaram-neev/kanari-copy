# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feedback do
    code "12345"
    food_quality 1
    speed_of_service 1
    friendliness_of_service -1
    ambience 0
    cleanliness 1
    value_for_money -1
    comment "Was pretty okay"
    recommendation_rating 9
    completed true
    points 1
    user nil
    outlet nil
  end
end
