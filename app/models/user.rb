class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  has_many :feedbacks, inverse_of: :user
  has_many :redemptions, inverse_of: :user
  has_many :managed_outlets, class_name: 'Outlet', foreign_key: 'manager_id'
  has_one :outlets_staff, foreign_key: 'staff_id' # For restaurant staff only
  has_one :employed_outlet, source: 'outlet', through: :outlets_staff, foreign_key: 'staff_id' # For restaurant staff only
  has_one :customers_user
  has_one :employed_customer, source: 'customer', through: :customers_user # For all users except mobile users

  def full_name
    return [first_name, last_name].join(' ').strip
  end

  def customer
    case role
    when 'customer_admin'
      return Customer.where(customer_admin_id: id).first
    when 'manager'
      outlet = managed_outlets.first
      if !outlet.nil?
        return outlet.customer
      else
        employed_customer
      end
    when 'staff'
      outlet = employed_outlet
      if !outlet.nil?
        return outlet.customer
      end
    else
      return nil
    end
  end

  def outlets
    case role
    when 'kanari_admin'
      Outlet.all
    when 'customer_admin'
      customer.nil? ? [] : customer.outlets
    when 'manager'
      managed_outlets
    when 'staff'
      Array(employed_outlet)
    when 'user'
      Outlet.where(disabled: false)
    else
      return []
    end
  end

  def registration_complete?
    if role == 'customer_admin'
      !customer.nil?
    else
      return true
    end
  end

end
