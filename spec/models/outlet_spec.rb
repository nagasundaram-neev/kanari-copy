require 'spec_helper'

describe Outlet do
  it { should belong_to(:customer) }
  it { should have_many(:feedbacks) }
  it { should have_many(:redemptions) }
  it { should belong_to(:manager).class_name('User') }
  it { should have_many(:outlets_cuisine_types) }
  it { should have_many(:cuisine_types).through(:outlets_cuisine_types) }
  it { should have_many(:outlets_outlet_types) }
  it { should have_many(:outlet_types).through(:outlets_outlet_types) }
  it { should have_many(:outlets_staffs) }
  it { should have_many(:staffs).through(:outlets_staffs) }
end

describe "#points_pending_redemption" do
  it "should return the total points of redemptions yet to be approved" do
    staff_user = FactoryGirl.create(:user, role: 'staff')
    outlet = FactoryGirl.create(:outlet)
    approved_redemption = FactoryGirl.create(:redemption, staff: staff_user, outlet: outlet, points: 100)
    pending_redemption_1 = FactoryGirl.create(:redemption, outlet: outlet, points: 100)
    pending_redemption_2 = FactoryGirl.create(:redemption, outlet: outlet, points: 100)
    outlet.points_pending_redemption.should == 200
  end
end

describe "#redeemable_points" do
  it "should return points which are not locked for redemption" do
    staff_user = FactoryGirl.create(:user, role: 'staff')
    outlet = FactoryGirl.create(:outlet, rewards_pool: 1000)
    approved_redemption = FactoryGirl.create(:redemption, staff: staff_user, outlet: outlet, points: 100)
    pending_redemption_1 = FactoryGirl.create(:redemption, outlet: outlet, points: 100)
    pending_redemption_2 = FactoryGirl.create(:redemption, outlet: outlet, points: 100)
    outlet.redeemable_points.should == 800
  end
end
