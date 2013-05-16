json.array!(@payment_invoices) do |payment_invoice|
  json.extract! payment_invoice, :kanari_invoice_id, :receipt_date, :amount_paid, :customer_id
  json.url payment_invoice_url(payment_invoice, format: :json)
end