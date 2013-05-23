class CreatePaymentInvoices < ActiveRecord::Migration
  def change
    create_table :payment_invoices do |t|
      t.integer :kanari_invoice_id
      t.datetime :receipt_date
      t.string :amount_paid
      t.references :customer, index: true

      t.timestamps
    end
  end
end
