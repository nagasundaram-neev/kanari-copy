class Api::V1::ManagersController < ApplicationController
  before_action :authenticate_user!

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

  private

    def create_manager_params
      params.fetch(:user).permit([:email, :first_name, :last_name, :password, :password_confirmation, :phone_number])
    end
end
