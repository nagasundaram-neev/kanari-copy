
And "the following cuisine types exist" do |cuisine_types|
  cuisine_params = cuisine_types.hashes
  CuisineType.create!(cuisine_params)
end
