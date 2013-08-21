class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  has_many :feedbacks, inverse_of: :user
  has_many :redemptions, inverse_of: :user
  has_many :social_network_accounts, inverse_of: :user
  has_many :managed_outlets, class_name: 'Outlet', foreign_key: 'manager_id'
  has_one :outlets_staff, foreign_key: 'staff_id' # For restaurant staff only
  has_one :employed_outlet, source: 'outlet', through: :outlets_staff, foreign_key: 'staff_id' # For restaurant staff only
  has_one :customers_user
  has_one :employed_customer, source: 'customer', through: :customers_user # For all users except mobile users

  scope :staff,   -> { where(role:'staff')}
  scope :manager, -> { where(role:'manager')}

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

  # Lists all activities (redemption and feedback) by the user
  def activities
    activities = [];all_activities = []
    all_activities << RedemptionLog.user_activities(self)
    all_activities << FeedbackLog.user_activities(self)
    sorted_activities = all_activities.flatten.compact.sort_by!{|activity| activity.updated_at }.reverse
    sorted_activities.each do |activity|
      activities << {points: activity.points, outlet_id: activity.outlet_id, outlet_name: activity.outlet_name,
                     type: activity.class.name.gsub(/Log/i,''), updated_at: activity.updated_at}
    end
    activities
  end

  def outlets
    case role
    when 'kanari_admin'
      Outlet.unscoped
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

  def is_active?
    case role
    when 'user', 'kanari_admin', 'customer_admin'
      return true
    when 'manager'
      managed_outlets.length >= 1
    when 'staff'
      Array(employed_outlet).length >= 1
    end
  end

  def registration_complete?
    if role == 'customer_admin'
      !customer.nil?
    else
      return true
    end
  end

  def update_points_and_feedbacks_count(points)
    self.with_lock do
      self.points_available = self.points_available.to_i + points
      self.feedbacks_count = self.feedbacks_count.to_i + 1
      self.last_activity_at = Time.zone.now
      self.save
    end
  end

  def update_points_and_redeems_count(points)
    self.with_lock do
      self.points_available = self.points_available.to_i - points
      self.points_redeemed  = self.points_redeemed.to_i + points
      self.redeems_count    = self.redeems_count.to_i + 1
      self.save
    end
  end

  def tablet_id
    self.role == 'staff' ? self.email.split('@').first : nil
  end
end
