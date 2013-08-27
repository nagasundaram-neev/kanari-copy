class PaymentInvoiceSerializer < ActiveModel::Serializer
  attributes :id, :kanari_invoice_id, :receipt_date, :amount_paid, :outlet_id, :kanari_plan, :invoice_url
end
