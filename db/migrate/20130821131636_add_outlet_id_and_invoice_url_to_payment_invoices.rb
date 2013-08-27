class AddOutletIdAndInvoiceUrlToPaymentInvoices < ActiveRecord::Migration
  def up
    add_column :payment_invoices, :outlet_id, :integer
    add_column :payment_invoices, :invoice_url, :string
    add_column :payment_invoices, :kanari_plan, :string
  end
  def down
    remove_column :payment_invoices, :outlet_id
    remove_column :payment_invoices, :invoice_url
    remove_column :payment_invoices, :kanari_plan
  end
end
