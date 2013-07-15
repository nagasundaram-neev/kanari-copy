And /^the customer with id "([^"]*)" has an outlet named "([^"]*)"$/  do |customer_id, outlet_name|
  @outlet = Outlet.create!(name: outlet_name, customer_id: customer_id)
  @outlet.disabled.should be_false
end

And /^the customer with id "([^"]*)" has an outlet named "([^"]*)" with manager "([^"]*)"$/  do |customer_id, outlet_name, manager_email|
  manager = User.where(email: manager_email).first
  @outlet = Outlet.create!(name: outlet_name, customer_id: customer_id, manager: manager)
  @outlet.disabled.should be_false
end

And /^the customer with id "([^"]*)" has an outlet named "([^"]*)" with id "([^"]*)" with manager "([^"]*)"$/  do |customer_id, outlet_name, outlet_id, manager_email|
  manager = User.where(email: manager_email).first
  @outlet = Outlet.create!(id: outlet_id, name: outlet_name, customer_id: customer_id, manager: manager)
  @outlet.disabled.should be_false
end

And /^the outlet has "([^"]*)" points in its rewards pool$/ do |points|
  @outlet.rewards_pool = points
  @outlet.save!
end

And /^the customer with id "([^"]*)" has an outlet named "([^"]*)" with id "([^"]*)"$/  do |customer_id, outlet_name, outlet_id|
  @outlet = Outlet.create!(id: outlet_id, name: outlet_name, customer_id: customer_id)
  @outlet.disabled.should be_false
end

And /^the outlet's id is "([^"]*)"$/ do |id|
  @outlet.id = id
  @outlet.save
end

Given(/^the outlet doesn't have any feedback$/) do
  @outlet.feedbacks = []
  @outlet.save
end


And /^the outlet's cuisine types should be "([^"]*)"$/ do |cuisine_types|
  @outlet.cuisine_types.collect(&:name).should =~ cuisine_types.split(',')
end

And /^the outlet's outlet types should be "([^"]*)"$/ do |outlet_types|
  @outlet.outlet_types.collect(&:name).should =~ outlet_types.split(',')
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

Given /^outlet "(.*?)" was created before "(.*?)" days$/ do |outlet_name, created_ago|
  outlet = Outlet.where(name: outlet_name).first
  outlet.created_at = Time.zone.now - created_ago.to_i.days
  outlet.save!
end

And /^the outlet's rewards pool should have "([^"]*)" points$/ do |points|
  @outlet.reload.rewards_pool.should == points.to_i
end

Given(/^the outlet's email is "(.*?)"$/) do |email|
  @outlet.email = email
  @outlet.save!
end

Then(/^the outlet's email should still be "(.*?)"$/) do |email|
  @existing_outlet.email.should == email
end

Then(/^the outlet's latitude and longitude should be "(.*?)" and "(.*?)"$/) do |latitude, longitude|
  @existing_outlet.latitude.should == latitude.to_f
  @existing_outlet.longitude.should == longitude.to_f
end

