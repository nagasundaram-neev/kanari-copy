# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment_invoice do
    kanari_invoice_id 1
    receipt_date "2013-05-14 00:30:26"
    amount_paid "MyString"
    customer nil
  end
end
