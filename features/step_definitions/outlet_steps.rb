And /^the customer with id "([^"]*)" has an outlet named "([^"]*)"$/  do |customer_id, outlet_name|
  @outlet = Outlet.create!(name: outlet_name, customer_id: customer_id)
  @outlet.disabled.should be_false
end

And /^the customer with id "([^"]*)" has an outlet named "([^"]*)" with manager "([^"]*)"$/  do |customer_id, outlet_name, manager_email|
  manager = User.where(email: manager_email).first
  @outlet = Outlet.create!(name: outlet_name, customer_id: customer_id, manager: manager)
  @outlet.disabled.should be_false
end

And /^the outlet's id is "([^"]*)"$/ do |id|
  @outlet.id = id
  @outlet.save
end

And /^the outlet "([^"]*)" should be present under customer with id "([^"]*)"$/ do |outlet_name, customer_id|
  @existing_outlet = Outlet.where(name: outlet_name).first
  Customer.find(customer_id).outlets.should == [@existing_outlet]
end

And "the outlet should be disabled" do
  @existing_outlet.disabled.should == true
end

Given /^outlet "(.*?)" has staffs$/ do |outlet_name, table|
  # table is a Cucumber::Ast::Table
  staff_emails = table.raw.flatten
  outlet = Outlet.where(name: outlet_name).first
  outlet.staffs = User.where(email: staff_emails)
  outlet.save!
end
