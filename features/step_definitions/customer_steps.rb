Given /^a customer named "([^"]*)" exists with id "([^"]*)"$/ do |customer_name, id|
  Customer.create!(name: customer_name, id: id)
end

And /^the outlet "([^"]*)" should be created under customer with id "([^"]*)"$/ do |outlet_name, customer_id|
  Customer.find(customer_id).outlets.should == [Outlet.where(name: outlet_name).first]
end
