class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    case user.role
    when 'kanari_admin'
      #Kanari admin's permissions
      can :create, PaymentInvoice
      can :read, Outlet
      can :read, :audit_logs
      can :read_feedbacks, Outlet
      can :read_all, Customer
      can :read, Customer
      can :read_all_redemptions, Outlet
      can :disable, Outlet
      can :approve_redemptions, Outlet
      can :create, OutletType
      can :create, CuisineType
    when 'customer_admin'
      #Customer admin's permissions
      can :read, PaymentInvoice
      can :create, Customer
      can :update, Customer, customer_admin_id: user.id
      can :read, Customer, customer_admin_id: user.id
      can :read_all_redemptions, Outlet, customer: user.customer
      can :approve_redemptions, Outlet, customer: user.customer
      can :manage, Outlet, customer: user.customer
      can :create, Outlet
      can :create, User, role: 'manager'
      can :update, User, role: 'manager'
      can :update, User, role: 'staff'
      can :destroy, User, role: 'manager'
      can :read, User, role: 'manager'
      can :generate_code, Outlet, customer: user.customer
      can :read_feedbacks, Outlet, customer: user.customer
      can :read_trends, Outlet, customer: user.customer
      can :create_staff, Outlet, customer: user.customer
      can :list_staff, Outlet, customer: user.customer
      can :delete_staff, Outlet, customer: user.customer
    when 'manager'
      can :read, Outlet, manager_id: user.id
      can :manage, Outlet, manager_id: user.id
      can :create_staff, Outlet, manager_id: user.id
      can :list_staff, Outlet, manager_id: user.id
      can :delete_staff, Outlet, manager_id: user.id
      can :update, User, role: 'staff'
      can :read_feedbacks, Outlet, manager_id: user.id
      can :read_trends, Outlet, manager_id: user.id
      can :read_all_redemptions, Outlet, manager_id: user.id
      can :approve_redemptions, Outlet, manager_id: user.id
      can :generate_code, Outlet, manager_id: user.id
    when 'staff'
      can :read, Outlet, id: (user.employed_outlet.id rescue nil)
      can :read_feedbacks, Outlet, id: (user.employed_outlet.id rescue nil)
      can :read_all_redemptions, Outlet, id: (user.employed_outlet.id rescue nil)
      can :approve_redemptions, Outlet, id: (user.employed_outlet.id rescue nil)
      can :generate_code, Outlet, id: (user.employed_outlet.id rescue nil)
    when 'user'
      can :create, Feedback
      can :read, Outlet, disabled: false
      can :request, Redemption
    else
      #Default permissions
    end
  end
end
