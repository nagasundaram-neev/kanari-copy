class PaymentInvoice < ActiveRecord::Base
  belongs_to :customer, inverse_of: :payment_invoices
end
