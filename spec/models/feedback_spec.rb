require 'spec_helper'

describe Feedback do
  it { should belong_to(:user)  }
  it { should belong_to(:outlet)  }
  it { should belong_to(:staff).class_name('User')  }
end
