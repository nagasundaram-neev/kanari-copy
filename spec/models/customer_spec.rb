require 'spec_helper'

describe Customer do
  it { should belong_to(:customer_admin).class_name('User') }
  it { should have_many(:payment_invoices) }
  it { should have_many(:outlets) }
end
