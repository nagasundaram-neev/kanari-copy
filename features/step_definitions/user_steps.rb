Given /^".*" is a user with email id "([^"]*)" and password "([^"]*)"$/ do |email, password|
  @user = User.create(email: email, password: password, password_confirmation: password)
end

And /^his authentication token is "([^"]*)"$/ do |auth_token|
  @user.authentication_token = auth_token
  @user.save!
end

And /^his role is "([^"]*)"$/ do |role|
  @user.role = role
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

And "$token should belong to the new inactive user that was created" do |token|
  JsonSpec.remember(token).should == User.invitation_not_accepted.last.invitation_token.to_json
end

And /^"([^"]*)" should receive an email with password reset link$/ do |email|
  step "\"#{email}\" should receive an email with subject /Reset password instructions/"
  open_last_email
  @user.reload
  reset_password_token = @user.reset_password_token
  step "I should see \"reset_password_token=#{reset_password_token}\" in the email body"
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

And /^he is the admin for customer "([^"]*)"$/ do |customer_name|
  customer = Customer.where(name: customer_name).first
  customer.customer_admin_id = @user.id
  customer.save!
end

Given /^"([^"]*)" received an invitation with token "([^"]*)"$/ do |email, invitation_token|
  @user = User.new(email: email, invitation_token: invitation_token, invitation_sent_at: Time.now.utc)
  @user.save!(validate: false)
end
