Given /^"([^"]*)" is a user with email id "([^"]*)" and password "([^"]*)"$/ do |full_name, email, password|
  first_name, last_name = full_name.split
  @user = User.create(email: email, password: password, password_confirmation: password, first_name: first_name.to_s, last_name: last_name.to_s)
end

Given "the following users exist" do |user_data|
  user_hashes = user_data.hashes
  user_hashes.each do |user_hash|
    user_hash["password_confirmation"] = user_hash["password"]
    user_hash["confirmed_at"] = Time.now
    User.create!(user_hash)
  end
  User.count.should == user_hashes.size
end

Given /^"([^"]*)" is a user with email id "([^"]*)" and password "([^"]*)" and user id "([^"]*)"$/ do |full_name, email, password, user_id|
  first_name, last_name = full_name.split
  @user = User.create(id: user_id, email: email, password: password, password_confirmation: password, first_name: first_name, last_name: last_name )
end

And /^his authentication token is "([^"]*)"$/ do |auth_token|
  @user.authentication_token = auth_token
  @user.confirmed_at = Time.now
  @user.save!
end

And /^his role is "([^"]*)"$/ do |role|
  @user.role = role
  @user.save!
end

And /^he has "([^"]*)" points$/ do |points|
  @user.points_available = points
  @user.save!
end

Given(/^his last activity was on "(.*?)"$/) do |last_activity_date|
  @user.last_activity_at = Time.zone.parse(last_activity_date)
  @user.save!
end

Then(/^the user's last activity should be today$/) do
  @user.last_activity_at.should_not be_nil
  @user.last_activity_at.to_date.should == Time.zone.now.to_date
end

Then(/^the user's last activity should be on "(.*?)"$/) do |last_activity_date|
  @user.last_activity_at.to_date.should == Time.zone.parse(last_activity_date).to_date
end

And /^he is giving feedback for the first time$/ do
  @user.feedbacks_count = nil
  @user.save!
end

And /^the user should have "([^"]*)" feedback count$/ do |feedback_count|
  @user.feedbacks_count.to_i.should == feedback_count.to_i
end

And /^he is redeeming points for the first time$/ do
  @user.redeems_count = nil
  @user.save!
end

And /^the user should have "([^"]*)" redeem count$/ do |redeem_count|
  @user.redeems_count.to_i.should == redeem_count.to_i
end

And(/^till now he has redeemed "(.*?)" points in "(.*?)" different redemptions$/) do |points_redeemed, redeems_count|
  @user.points_redeemed = points_redeemed
  @user.redeems_count = redeems_count.to_i
  @user.save!
end

And /^the auth_token should be different from "([^"]*)"$/ do |auth_token|
  @user.reload
  @user.authentication_token.should_not == auth_token
end

And /^the auth_token should still be "([^"]*)"$/ do |auth_token|
  @user.reload
  @user.authentication_token.should == auth_token
end

Given /^No user is present with email "([^"]*)"$/ do |email|
  User.where(email: email).delete_all
end

And /^the new user should have role "([^"]*)"$/ do |role|
  User.last.role.should == role
end

And "$token should belong to the new inactive user that was created" do |token|
  JsonSpec.remember(token).should == User.invitation_not_accepted.last.invitation_token.to_json
end

Then /^the user with email "([^"]*)" should have "([^"]*)" as his authentication_token$/ do |email, token|
  JsonSpec.remember(token).should == User.where(email: email).first.authentication_token.to_json
end

And /^"([^"]*)" should receive an email with password reset link$/ do |email|
  step "\"#{email}\" should receive an email with subject /Reset password instructions/"
  open_last_email
  @user.reload
  reset_password_token = @user.reset_password_token
  step "I should see \"reset_password_token=#{reset_password_token}\" in the email body"
end

And /^"([^"]*)" should receive an email with sign up confirmation link$/ do |email|
  step "\"#{email}\" should have 1 emails"
  step "\"#{email}\" should receive an email with subject /Confirmation instructions/"
  open_last_email
  @user = User.where(email: email).first
  @confirmation_token = @user.confirmation_token
  step "I should see \"confirmation/#{@confirmation_token}\" in the email body"
end

And /^unconfirmed email id "([^"]*)" should receive an email with confirmation link$/ do |email|
  step "\"#{email}\" should have 1 emails"
  step "\"#{email}\" should receive an email with subject /Confirmation instructions/"
  open_last_email
  @user = User.where(unconfirmed_email: email).first
  @confirmation_token = @user.confirmation_token
  step "I should see \"confirmation/#{@confirmation_token}\" in the email body"
end

And /^"([^"]*)" should receive another confirmation email with the same token$/ do |email|
  step "\"#{email}\" should have 2 emails"
  step "\"#{email}\" should receive an email with subject /Confirmation instructions/"
  open_last_email
  step "I should see \"confirmation/#{@confirmation_token}\" in the email body"
end

And /^"([^"]*)" should receive the kanari welcome mail$/ do |email|
  step "\"#{email}\" should receive an email with subject /Welcome to Kanari/"
  open_last_email
  @user = User.where(email: email).first
  step "I should see \"#{@user.first_name}\" in the email body"
end

And /his reset_password_token is "([^"]*)"/ do |reset_password_token|
  @user.reset_password_token = reset_password_token
  @user.reset_password_sent_at = Time.now.utc
  @user.save!
end

And /^his reset_password_token is more than "([^"]*)" hours old$/ do |time_in_hours|
  @user.reset_password_sent_at = Time.now - (time_in_hours.to_i.hours + 1.second)
  @user.save!
end

And /^his password should be "([^"]*)"$/ do |password|
  @user.reload
  @user.valid_password?(password).should be_true
end

And /^he should be under customer id "([^"]*)"$/ do |customer_id|
  @user.customer.should == Customer.find(customer_id)
end

And /^he is the admin for customer "([^"]*)"$/ do |customer_name|
  customer = Customer.where(name: customer_name).first
  customer.customer_admin_id = @user.id
  customer.save!
end

Given /^"([^"]*)" received an invitation with token "([^"]*)"$/ do |email, invitation_token|
  @user = User.new(email: email, invitation_token: invitation_token, invitation_sent_at: Time.now.utc)
  @user.save!(validate: false)
end

Given /^"([^"]*)" received a confirmation mail with token "([^"]*)"$/ do |email, confirmation_token|
  @user = User.new(email: email, password: 'Password123', password_confirmation: 'Password123')
  @user.save
  @user.update_attribute('confirmation_token', confirmation_token)
end

And /^a new user with email "([^"]*)" should be created$/ do |email|
  @user = User.last
  @user.email.should == email
end

And /^the user's full name should be "([^"]*)"$/ do |full_name|
  actual_full_name = @user.first_name + " " + @user.last_name
  actual_full_name.should == full_name
end

And /^the user's phone number should be "([^"]*)"$/ do |phone_number|
  @user.phone_number.should == phone_number
end

And /^a new user should not be created with email "([^"]*)"$/ do |email|
  User.where(email: email).first.should == nil
end

Given /^Password reset instuctions were sent to "([^"]*)"$/ do |email|
  @user = User.create(email: email, password: 'password123', password_confirmation: 'password123')
  User.send_reset_password_instructions(email: email)
end

When "he clicks on the password reset link" do
  open_last_email
  visit_in_email(/reset_password_token/)
end

Then(/^a user should be present with the following$/) do |table|
  User.where(table.rows_hash).present?.should be_true
end

Then(/^a user should be created with the following$/) do |table|
  User.where(table.rows_hash).present?.should be_true
end

And /^the user with email "([^"]*)" should have the following social network accounts$/ do |email, table|
  user = User.where(email: email).first
  table.hashes.each do |hash|
    user.social_network_accounts.where(hash).size.should == 1
  end
end

Given "the following user exists" do |table|
  a = User.create!(table.rows_hash.merge(confirmed_at: Time.now))
end

And /^the user should have "([^"]*)" points$/ do |points|
  @user.reload.points_available.should == points.to_i
end

And /^the user should have "([^"]*)" redeemed points$/ do |points|
  @user.reload.points_redeemed.should == points.to_i
end

Then(/^there should not be any user with email "(.*?)"$/) do |email|
  User.where(email: email).first.should be_nil
end

When /^"([^"]*)" confirms the sign up$/ do |email|
  user = User.where(email: email).first
  user.confirmed_at = Time.now
  user.save!
end
