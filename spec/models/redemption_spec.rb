require 'spec_helper'

describe Redemption do
  it { should belong_to(:user)  }
  it { should belong_to(:outlet)  }
  it { should belong_to(:staff).class_name('User')  }

  describe "#points_available?" do
    context "points are available" do
      it "should return true" do
        user = FactoryGirl.create(:user, points_available: 100, email: 'testuser@gmail.com')
        outlet = FactoryGirl.create(:outlet, rewards_pool: 1000)
        redemption = FactoryGirl.create(:redemption, user: user, outlet: outlet, points: 90)
        redemption.points_available?.should == true
      end
    end
    context "user doesn't have enough points" do
      it "should return true" do
        user = FactoryGirl.create(:user, points_available: 80, email: 'testuser@gmail.com')
        outlet = FactoryGirl.create(:outlet, rewards_pool: 1000)
        redemption = FactoryGirl.create(:redemption, user: user, outlet: outlet, points: 90)
        redemption.points_available?.should == false
      end
    end
    context "outlet doesn't have enough points" do
      it "should return true" do
        user = FactoryGirl.create(:user, points_available: 100, email: 'testuser@gmail.com')
        outlet = FactoryGirl.create(:outlet, rewards_pool: 80)
        redemption = FactoryGirl.create(:redemption, user: user, outlet: outlet, points: 90)
        redemption.points_available?.should == false
      end
    end
  end

end
