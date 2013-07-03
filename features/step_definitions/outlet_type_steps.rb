And "the following outlet types exist" do |outlet_types|
  outlet_params = outlet_types.hashes
  OutletType.create!(outlet_params)
end
Then /^an outlet type with name "([^"]*)" should exist$/ do |outlet_type_name|
  OutletType.where(name: outlet_type_name).count.should == 1
end
Then /^an outlet type with name "([^"]*)" should not exist$/ do |outlet_type_name|
  OutletType.where(name: outlet_type_name).count.should == 0
end
