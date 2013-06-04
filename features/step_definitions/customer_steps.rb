Given /^a customer named "([^"]*)" exists with id "([^"]*)"$/ do |customer_name, id|
  Customer.create!(name: customer_name, id: id)
end

Given /^a customer named "([^"]*)" exists with id "([^"]*)" with admin "([^"]*)"$/ do |customer_name, id, admin_email|
  customer_admin = User.where(email: admin_email).first
  Customer.create!(name: customer_name, id: id, customer_admin: customer_admin)
end

