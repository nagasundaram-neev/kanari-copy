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

Given /^No user is present with email "([^"]*)"$/ do |email|
  User.where(email: email).delete_all
end

And "$token should belong to the new inactive user that was created" do |token|
  JsonSpec.remember(token).should == User.invitation_not_accepted.last.invitation_token.to_json
end
