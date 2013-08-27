class PaymentInvoice < ActiveRecord::Base
  belongs_to :customer, inverse_of: :payment_invoices
  belongs_to :outlet,   inverse_of: :payment_invoices
end
