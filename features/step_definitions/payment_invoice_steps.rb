And /^the following payment invoices have been created$/ do |payment_invoices|
  PaymentInvoice.create(payment_invoices.hashes)
end

Then(/^the customer with id "(.*?)" should have a payment invoice with the following attributes$/) do |customer_id, table|
  customer = Customer.where(id: customer_id).first
  customer.should_not be_nil
  @payment_invoice = customer.payment_invoices.last
  @payment_invoice.should_not be_nil
  attributes = table.rows_hash
  attributes.each do |k, v|
    @payment_invoice.send(k).to_s.should == v.to_s
  end
end

Then(/^the payment invoice should have receipt date as "(.*?)"$/) do |date|
  @payment_invoice.should_not be_nil
  @payment_invoice.receipt_date.should == date
end
