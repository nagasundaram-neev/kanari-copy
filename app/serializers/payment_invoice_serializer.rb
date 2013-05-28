class PaymentInvoiceSerializer < ActiveModel::Serializer
  attributes :id, :kanari_invoice_id, :receipt_date, :amount_paid
end
