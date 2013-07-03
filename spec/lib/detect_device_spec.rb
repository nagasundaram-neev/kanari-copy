require 'spec_helper'
require 'detect_device'

describe DetectDevice do 

  class DummyClass
  end

  before(:all) do 
    @dummy_class = DummyClass.new
    @dummy_class.extend(DetectDevice)
  end

  describe "#is_mobile?" do

    it "should return true if the user is accessing through iPhone" do
      user_agent = "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7"
      @dummy_class.is_mobile?(user_agent).should be_true
    end
    
    it "should return true if the user is accessing through an android mobile" do
      user_agent = "Mozilla/5.0 (Linux; U; Android 4.0.3; ko-kr; LG-L160L Build/IML74K) AppleWebkit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30"
      @dummy_class.is_mobile?(user_agent).should be_true
    end

  end

  describe "#is_tablet?" do

    it "should return true if the user is accessing through iPad" do
      user_agent = "Mozilla/5.0(iPad; U; CPU iPhone OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B314 Safari/531.21.10"
      @dummy_class.is_tablet?(user_agent).should be_true
    end
    
    it "should return false if the user is accessing through an android mobile" do
      user_agent = "Mozilla/5.0 (Linux; U; Android 4.0.3; ko-kr; LG-L160L Build/IML74K) AppleWebkit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30"
      @dummy_class.is_tablet?(user_agent).should be_false
    end

  end

end
