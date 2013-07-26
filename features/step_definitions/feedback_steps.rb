When "the contents of $code should be a 5 digit number" do |code|
  code = JSON.parse("[#{JsonSpec.remember(code)}]")[0]
  code.match(/^\d\d\d\d\d$/).should_not be_nil
  Feedback.last.code.should == code
end

Given(/^A feedback exists with the following attributes:$/) do |table|
  @feedback = Feedback.create!(table.rows_hash)
end

And /^a new feedback entry should be created with (\d+) points$/ do |points|
  Feedback.last.points.should == points.to_i
end

Given(/^the time limit for giving feedback is "([^"]*)" minutes$/) do |time_limit|
  setting = GlobalSetting.where(setting_name: "feedback_expiry_time").first
  if setting.nil?
    GlobalSetting.create(setting_name: "feedback_expiry_time", setting_value: time_limit)
  else
    setting.update_attributes(setting_value: time_limit)
  end
end

Given(/^the time for giving feedback has been expired$/) do
  setting = GlobalSetting.where(setting_name: "feedback_expiry_time").first
  @feedback.created_at = Time.zone.now - (setting.setting_value.to_i + 5).minutes
  @feedback.save
end

Given "the following feedbacks exist" do |hashes|
  feedback_hashes = hashes.hashes
  feedback_hashes.each do |feedback_hash|
    Feedback.create!(feedback_hash)
  end
  Feedback.count.should == feedback_hashes.size
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

Then(/^the feedback with id "(.*?)" should be completed$/)do |feedback_id|
  Feedback.find(feedback_id).completed.should == true
end

Then(/^the feedback with id "(.*?)" should have kanari code$/)do |feedback_id|
  Feedback.find(feedback_id).code.should_not == nil
end

Then(/^the feedback with id "(.*?)" should not be completed$/)do |feedback_id|
  Feedback.find(feedback_id).completed.should_not == true
end

Given(/^there exists no feedback with id "(.*?)"$/) do |feedback_id|
  Feedback.delete(feedback_id)
end

Given(/^the following feedbacks exist for "(.*?)"$/) do |date, hashes|
  feedback_hashes = hashes.hashes
  feedback_hashes.each do |feedback_hash|
    feedback_hash.delete("updated_at")
    feedback_hash[:updated_at] = date
    Feedback.create!(feedback_hash)
  end
  Feedback.where(updated_at: date).count.should == feedback_hashes.size
end


Given(/^the following feedbacks exist for today$/) do |hashes|
  feedback_hashes = hashes.hashes
  today = Time.zone.now.beginning_of_day
  feedback_hashes.each do |feedback_hash|
    feedback_hash.delete("updated_at")
    feedback_hash[:updated_at] = today + 1.hours
    Feedback.create!(feedback_hash)
  end
  Feedback.where(updated_at: (today + 1.hours)).count.should == feedback_hashes.size
end

Given(/^the following feedbacks exist for yesterday$/) do |hashes|
  feedback_hashes = hashes.hashes
  yesterday = Time.zone.now.beginning_of_day - 1.day
  feedback_hashes.each do |feedback_hash|
    feedback_hash.delete("updated_at")
    feedback_hash[:updated_at] = yesterday + 1.hours
    Feedback.create!(feedback_hash)
  end
  Feedback.where(updated_at: (yesterday + 1.hours)).count.should == feedback_hashes.size
end
