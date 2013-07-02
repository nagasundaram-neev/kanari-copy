When "the contents of $code should be a 5 digit number" do |code|
  code = JSON.parse("[#{JsonSpec.remember(code)}]")[0]
  code.match(/^\d\d\d\d\d$/).should_not be_nil
  Feedback.last.code.should == code
end

Given(/^A feedback exists with the following attributes:$/) do |table|
  Feedback.create!(table.rows_hash)
end

And /^the feedback with id "([^"]*)" should have the following attributes$/ do |feedback_id, table|
  feedback = Feedback.find(feedback_id)
  attr = table.rows_hash
  feedback.food_quality.should == attr["food_quality"].to_i
  feedback.speed_of_service.should == attr["speed_of_service"].to_i
  feedback.friendliness_of_service.should == attr["friendliness_of_service"].to_i
  feedback.ambience.should == attr["ambience"].to_i
  feedback.cleanliness.should == attr["ceanliness"].to_i
  feedback.value_for_money.should == attr["value_for_money"].to_i
  feedback.comment.should == attr["comment"]
  feedback.recommendation_rating.to_s.should == attr["recommendation_rating"]
end

Then(/^the feedback with id "(.*?)" should belong to user with id "(.*?)"$/) do |feedback_id, user_id|
  Feedback.find(feedback_id).user_id.should == (user_id == "nil" ? nil : user_id.to_i)
end

Then(/^the feedback with id "(.*?)" should have no kanari code$/)do |feedback_id|
  Feedback.find(feedback_id).code.should == nil
end
