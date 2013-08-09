Given "A facebook user exists who has not registered with Kanari facebook app" do
  create_facebook_non_app_user
end

Given "A facebook user exists who has registered with Kanari facebook app" do
  @facebook_user_token ||= create_facebook_app_user
end

Given /^I will remember the access_token of "([^"]*)" for "([^"]*)" provider$/ do |email, provider|
  user = User.where(email: email).first
  @access_token = SocialNetworkAccount.where(provider: provider, user: user).first.access_token
end

Then /^access_token of "([^"]*)" for "([^"]*)" provider should not have changed$/ do |email, provider|
  user = User.where(email: email).first
  SocialNetworkAccount.where(provider: provider, user: user).first.access_token.should == @access_token
end
