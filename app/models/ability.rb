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
      can :read_all, Customer
      can :read, Customer
      can :read_pending_redemptions, Outlet
    when 'customer_admin'
      #Customer admin's permissions
      can :read, PaymentInvoice
      can :create, Customer
      can :update, Customer, customer_admin_id: user.id
      can :read, Customer, customer_admin_id: user.id
      can :read_pending_redemptions, Outlet
      can :manage, Outlet, customer: user.customer
      can :create, Outlet
      can :create, User, role: 'manager'
      can :read, User, role: 'manager'
      can :generate_code, Outlet, customer: user.customer
      cannot :create_staff, Outlet
    when 'manager'
      can :read, Outlet, manager_id: user.id
      can :create_staff, Outlet, manager_id: user.id
      can :read_pending_redemptions, Outlet
      can :generate_code, Outlet, manager_id: user.id
    when 'staff'
      can :read, Outlet, id: (user.employed_outlet.id rescue nil)
      can :read_pending_redemptions, Outlet
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
