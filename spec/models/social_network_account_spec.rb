require 'spec_helper'

describe SocialNetworkAccount do
  it { should belong_to(:user)  }

  describe ".valid_access_token?" do
    context "when provider is facebook" do
      it "should return true when access_token is valid" do
        response = double(Net::HTTPResponse)
        long_lived_access_token = 'access_token_123'
        response.stub(code: '200', body: {access_token: long_lived_access_token}.to_param)
        Net::HTTP.should_receive(:get_response).and_return(response)
        short_lived_access_token = 'test123'
        SocialNetworkAccount.valid_access_token?('facebook', short_lived_access_token).should be_true
      end
      it "should replace short lived access_token with long lived access token" do
        response = double(Net::HTTPResponse)
        long_lived_access_token = 'access_token_123'
        response.stub(code: '200', body: {access_token: long_lived_access_token}.to_param)
        Net::HTTP.should_receive(:get_response).and_return(response)
        short_lived_access_token = 'test123'
        SocialNetworkAccount.valid_access_token?('facebook', short_lived_access_token).should be_true
        short_lived_access_token.should == long_lived_access_token
      end
      it "should return false when response code is not success" do
        response = double(Net::HTTPResponse)
        response.stub(code: '422', body: {error: 'ah, screw you'}.to_json)
        Net::HTTP.should_receive(:get_response).and_return(response)
        SocialNetworkAccount.valid_access_token?('facebook', 'test1234').should be_false
      end
    end
    context "when provider is not facebook" do
      it "should return true when email is valid" do
        SocialNetworkAccount.valid_access_token?('facebook', 'test1234').should be_false
      end
    end
  end

end
