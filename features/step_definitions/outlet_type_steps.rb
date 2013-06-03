And "the following outlet types exist" do |outlet_types|
  outlet_params = outlet_types.hashes
  OutletType.create!(outlet_params)
end
