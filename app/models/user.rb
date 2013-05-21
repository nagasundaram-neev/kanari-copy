class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  has_many :feedbacks, inverse_of: :user
  has_many :managed_outlets, class_name: 'Outlet', foreign_key: 'manager_id'
  has_one :outlets_staff, foreign_key: 'staff_id' # For restaurant staff only
  has_one :employed_outlet, source: 'outlet', through: :outlets_staff, foreign_key: 'staff_id' # For restaurant staff only
end
