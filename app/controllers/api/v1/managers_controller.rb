class Api::V1::ManagersController < ApplicationController
  before_action :authenticate_user!

  respond_to :json

  #POST /managers
  def create
    user = User.new(create_manager_params)
    user.role = "manager"
    authorize! :create, user
    if user.save
      render json: { manager: { id: user.id } }, status: :created
    else
      render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  #GET /managers
  def index
    authorize! :read, User
    #TODO: Query to be optimized
    managers = current_user.customer.outlets.collect(&:manager).uniq
    render json: managers, each_serializer: ManagerSerializer
  end

  private

    def create_manager_params
      params.fetch(:user).permit([:email, :first_name, :last_name, :password, :password_confirmation, :phone_number])
    end
end
