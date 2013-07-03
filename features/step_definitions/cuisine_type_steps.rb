And "the following cuisine types exist" do |cuisine_types|
  cuisine_params = cuisine_types.hashes
  CuisineType.create!(cuisine_params)
end

Then /^a cuisine type with name "([^"]*)" should exist$/ do |cuisine_type_name|
  CuisineType.where(name: cuisine_type_name).count.should == 1
end

Then /^a cuisine type with name "([^"]*)" should not exist$/ do |cuisine_type_name|
  CuisineType.where(name: cuisine_type_name).count.should == 0
end
