And /^the following payment invoices have been created$/ do |payment_invoices|
  PaymentInvoice.create(payment_invoices.hashes)
end
