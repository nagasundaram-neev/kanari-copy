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
    unassigned_managers = User.manager.includes(:employed_customer).where(customers: {id: current_user.customer.id}) rescue []
    managers = (assigned_managers + unassigned_managers).uniq
    managers.delete(nil)
    render json: managers, each_serializer: ManagerSerializer
  end

  #GET /manager/1
  def show
    manager = User.where(role: 'manager', id: params[:id]).first
    render json: {errors: ["Manager record not found"]}, status: :not_found and return if manager.blank?
    authorize! :read, manager 
    if(manager.employed_customer != current_user.customer)
      render json: {errors: ["Insufficient privileges"]}, status: :forbidden and return
    end
    render json: manager, serializer: ManagerSerializer
  end

  #PUT /managers/1
  def update
    manager = User.where(role: 'manager', id: params[:id]).first
    render json: {errors: ["Manager record not found"]}, status: :not_found and return if manager.blank?
    authorize! :update, manager 
    if(manager.employed_customer != current_user.customer)
      render json: {errors: ["Insufficient privileges"]}, status: :forbidden and return
    end
    if manager.update(update_manager_params)
      render json: nil, status: :ok
    else
      render json: {errors: manager.errors.full_messages}, status: :unprocessable_entity
    end
  end

  #DELELTE /managers/1
  def destroy
    manager = User.where(role: 'manager', id: params[:id]).first
    render json: {errors: ["Manager record not found"]}, status: :not_found and return if manager.blank?
    authorize! :destroy, manager 
    if(manager.employed_customer != current_user.customer)
      render json: {errors: ["Insufficient privileges"]}, status: :forbidden and return
    end
    if manager.destroy
      render json: nil, status: :ok
    else
      render json: {errors: manager.errors.full_messages}, status: :unprocessable_entity
    end
  end
  
  private

  def create_manager_params
    params.fetch(:user).permit([:email, :first_name, :last_name, :password, :password_confirmation, :phone_number])
  end
  
  def update_manager_params
    params.fetch(:manager).permit([:email, :first_name, :last_name, :password, :password_confirmation, :phone_number])
  end

end
