Given "the following redemptions exist" do |hashes|
  redemption_hashes = hashes.hashes
  redemption_hashes.each do |redemption_hash|
    approved = redemption_hash.delete("approved")
    redemption_hash[:approved_by] = (approved.to_s == "false" ? nil : User.last.id)
    Redemption.create!(redemption_hash)
  end
  Redemption.count.should == redemption_hashes.size
end

Then(/^the staff "(.*?)" should have approved the redemption with id "(.*?)"$/) do |stafff_email, redemption_id|
  staff = User.find_by_email(stafff_email)
  @redemption = Redemption.find(redemption_id).approved_by.should == staff.id
end