require 'spec_helper'

describe PaymentInvoice do
  it { should belong_to(:customer)  }
end
