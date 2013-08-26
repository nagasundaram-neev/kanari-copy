Given /^a customer named "([^"]*)" exists with id "([^"]*)"$/ do |customer_name, id|
  Customer.create!(name: customer_name, id: id)
end

Given /^a customer named "([^"]*)" exists with id "([^"]*)" with admin "([^"]*)"$/ do |customer_name, id, admin_email|
  customer_admin = User.where(email: admin_email).first
  Customer.create!(name: customer_name, id: id, customer_admin: customer_admin)
end

Then(/^the "(.*?)" of customer with id "(.*?)" should be "(.*?)"$/) do |attribute, id, value|
  customer = Customer.find(id)
  customer.send(attribute).to_s.should == value.to_s
end

Given(/^the maximum number of authorized outlets for customer with id "(.*?)" is "(.*?)"$/) do |customer_id, authorized_outlets|
  customer = Customer.where(id: customer_id).first
  customer.should_not be_nil
  customer.authorized_outlets = authorized_outlets
  customer.save
end
