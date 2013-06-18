Given "the following redemptions exist" do |hashes|
  redemption_hashes = hashes.hashes
  redemption_hashes.each do |redemption_hash|
    approved = redemption_hash.delete("approved")
    redemption_hash[:approved_by] = (approved.to_s == "false" ? nil : User.last.id)
    Redemption.create!(redemption_hash)
  end
  Redemption.count.should == redemption_hashes.size
end
