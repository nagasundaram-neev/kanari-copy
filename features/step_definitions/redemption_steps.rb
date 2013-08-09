Given "the following redemptions exist" do |hashes|
  redemption_hashes = hashes.hashes
  redemption_hashes.each do |redemption_hash|
    approved = redemption_hash.delete("approved")
    redemption_hash[:approved_by] = (approved.to_s == "false" ? nil : User.last.id)
    Redemption.create!(redemption_hash)
  end
  Redemption.count.should == redemption_hashes.size
end

Given(/^the following redemptions exist for "(.*?)"$/) do |date, hashes|
  redemption_hashes = hashes.hashes
  redemption_hashes.each do |redemption_hash|
    approved = redemption_hash.delete("approved")
    redemption_hash.delete("updated_at")
    redemption_hash.delete("created_at")
    redemption_hash[:created_at] = date
    redemption_hash[:updated_at] = date
    redemption_hash[:approved_by] = (approved.to_s == "false" ? nil : User.last.id)
    Redemption.create!(redemption_hash)
  end
  Redemption.where(updated_at: date).count.should == redemption_hashes.size
end

Given(/^A redemption request exists with the following attributes:$/) do |table|
  redemption_hash = table.rows_hash
  approved        = redemption_hash.delete("approved")
  redemption_hash[:approved_by] = (approved.to_s == "false" ? nil : User.last.id)
  @redemption = Redemption.create!(redemption_hash)
end

Then(/^the staff "(.*?)" should have approved the redemption with id "(.*?)"$/) do |stafff_email, redemption_id|
  staff = User.find_by_email(stafff_email)
  @redemption = Redemption.find(redemption_id)
  @redemption.should_not be_nil
  @redemption.approved_by.should == staff.id
end

Given(/^the time limit for approving redemption is "([^"]*)" minutes$/) do |time_limit|
  setting = GlobalSetting.where(setting_name: "redemption_expiry_time").first
  if setting.nil?
    GlobalSetting.create(setting_name: "redemption_expiry_time", setting_value: time_limit)
  else
    setting.update_attributes(setting_value: time_limit)
  end
end

Given(/^the time for approving redemption has been expired$/) do
  setting = GlobalSetting.where(setting_name: "redemption_expiry_time").first
  @redemption.created_at = Time.zone.now - (setting.setting_value.to_i + 5).minutes
  @redemption.save
end

Then (/^the redemption should have been approved in last "(.*?)" minutes$/) do |time|
  @redemption.should_not be_nil
  @redemption.approved_at.should_not be_nil
  @redemption.approved_at.should_not <= Time.zone.now - time.to_i.minutes 
end
