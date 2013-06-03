Given /^a customer named "([^"]*)" exists with id "([^"]*)"$/ do |customer_name, id|
  Customer.create!(name: customer_name, id: id)
end
