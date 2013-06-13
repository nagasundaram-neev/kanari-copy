And /^the following managers have been created$/ do |managers|
  managers.hashes.each do |hash|
    outlet = Outlet.where(name: hash[:outlet_name]).first
    manager = User.where(id: hash[:manager_id].to_i).first
    if manager.nil?
      manager = User.new(id: hash[:manager_id], email: hash[:email], first_name: hash[:first_name],
                         last_name: hash[:last_name], phone_number: hash[:phone_number],
                         password: 'password123', password_confirmation: 'password123', role: 'manager')
    end
    manager.managed_outlets << outlet
    manager.save!
  end
end

And /^"([^"]*)" should have "([^"]*)" as the manager$/ do |outlet_name, manager_email|
  Outlet.where(name: outlet_name).first.manager_id.should == User.where(email: manager_email).first.id
end

Given(/^an unassigned manager exists with the following attributes for customer (\d+)$/) do |customer_id, table|
  user = User.new(table.rows_hash)
  user.role = 'manager'
  user.employed_customer = Customer.find(customer_id)
  user.save
end

