require 'spec_helper'

describe SocialNetworkAccount do
  it { should belong_to(:user)  }
end
