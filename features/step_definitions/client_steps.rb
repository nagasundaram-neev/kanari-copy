Given "$name is a client with email id $email" do |name, email|
  @name = name
  @email = email
end

And "he is invited to create an account on the site" do
  reset_mailer
  step "send registration invitation to #{@name} on email id #{@email}"
end

Then "he receives an email with a link to the registration process" do
  #step "#{@email} should receive an email"
  open_last_email
  step "he should see \"invitation_token\" in the email body"
end
When "he clicks on the link to the registration process" do
  open_last_email
  click_email_link_matching(/invitation_token/)
end

Then "he is taken to a page to fill in account information" do
  page.should have_content('Set your password')
end

When "he fills in the required information in registration page" do
  #TODO: Fill in required information
end

And "he fills in password and password confirmation as $password" do |password|
  fill_in('Password', with: password)
  fill_in('Password confirmation', with: password)
end

And "submits the registration form" do
  click_on('Set my password')
end

Then /^user with email "([^"]*)" should be registered$/ do |email|
  User.where(email: email).first.invitation_accepted?.should be_true
end

Then "$user should be logged in" do |user|
  page.should have_content('Logout')
end

