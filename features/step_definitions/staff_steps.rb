Given(/^there exists no staff$/) do
  User.staff.destroy_all
end

Then (/^a staff should be created for outlet "([^"]*)" and customer "([^"]*)"$/) do |outlet_id, customer_id|
  staff = User.last
  staff.role.should == 'staff'
  staff.employed_customer.should == Customer.find(customer_id.to_i)
  staff.employed_outlet.should == Outlet.find(outlet_id.to_i)
end

Then "the contents of $staff_id should be the last staff's id" do |staff_id|
  staff_id = JSON.parse("[#{JsonSpec.remember(staff_id)}]")[0]
  User.staff.last.id.to_s.should == staff_id.to_s
end

Then "the contents of $tablet_id should be the last created tablet id" do |tablet_id|
  tablet_id = JSON.parse("[#{JsonSpec.remember(tablet_id)}]")[0]
  User.staff.last.email.split("@").first.to_s.should == tablet_id.to_s
end

Then "the contents of $tablet_id should be a 6 digit number" do |tablet_id|
  tablet_id = JSON.parse("[#{JsonSpec.remember(tablet_id)}]")[0]
  tablet_id.length.should == 6
  tablet_id.match(/^\d\d\d\d\d\d$/).should_not be_nil
end

Then(/^there should be only one staff with tablet_id "(.*?)"$/) do |tablet_id|
  User.staff.count.should == 1
  User.staff.first.email.split('@').first.to_s.should == tablet_id
end
