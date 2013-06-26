class Api::V1::ManagersController < ApplicationController
  before_action :authenticate_user!

  respond_to :json

  #POST /managers
  def create
    user = User.new(create_manager_params)
    user.role = "manager"
    authorize! :create, user
    if user.save
      user.employed_customer = current_user.customer
      user.managed_outlets << Outlet.find(params[:user][:outlet_id]) unless params[:user][:outlet_id].nil?
      render json: { manager: { id: user.id } }, status: :created
    else
      render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  #GET /managers
  def index
    authorize! :read, User
    #TODO: Query to be optimized
    assigned_managers = current_user.customer.outlets.collect(&:manager) rescue []
    unassigned_managers = User.includes(:employed_customer).where(customers: {id: current_user.customer.id}) rescue []
    managers = (assigned_managers + unassigned_managers).uniq
    managers.delete(nil)
    render json: managers, each_serializer: ManagerSerializer
  end

  private

    def create_manager_params
      params.fetch(:user).permit([:email, :first_name, :last_name, :password, :password_confirmation, :phone_number])
    end
end
