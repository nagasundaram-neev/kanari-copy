class Api::V1::StaffsController < ApplicationController
  before_action :authenticate_user!

  respond_to :json

  def create
    outlet = Outlet.find(params[:outlet_id])
    authorize! :create_staff, outlet
    random_password = Devise.friendly_token
    user = User.new(email: "#{User.count}@kanari.co", password: random_password, password_confirmation: random_password)
    authentication_token = user.reset_authentication_token
    user.role = "staff"
    if user.save
      user.employed_outlet = Outlet.find(params[:outlet_id])
      user.employed_customer = current_user.customer
      render json: { staff_id: user.id, auth_token: authentication_token }, status: :created
    else
      render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
    end
  end

end
