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