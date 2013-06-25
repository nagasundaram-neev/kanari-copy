Then (/^a staff should be created for outlet "([^"]*)" and customer "([^"]*)"$/) do |outlet_id, customer_id|
  staff = User.last
  staff.role.should == 'staff'
  staff.employed_customer.should == Customer.find(customer_id.to_i)
  staff.employed_outlet.should == Outlet.find(outlet_id.to_i)
end
