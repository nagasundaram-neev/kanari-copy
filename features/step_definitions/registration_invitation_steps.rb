When /^send registration invitation to "([^"]*)" on email id "([^"]*)"$/ do |name, email|
  User.invite!(email: email, first_name: name)
end
