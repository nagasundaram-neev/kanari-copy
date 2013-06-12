class Customer < ActiveRecord::Base
  belongs_to :customer_admin, -> { where role: 'customer_admin'  } , class_name: 'User'
  has_many :payment_invoices, inverse_of: :customer
  has_many :outlets, inverse_of: :customer
  has_many :customers_users
  has_many :users, through: :customers_users
end
