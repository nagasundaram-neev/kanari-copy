class Api::V1::StaffsController < ApplicationController
  before_action :authenticate_user!

  respond_to :json

  def create
    outlet = Outlet.find(params[:user][:outlet_id])
    authorize! :create_staff, outlet
    dummy_email = "#{params[:user][:username]}@kanari.co"
    user = User.new(email: dummy_email, password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
    user.role = "staff"
    if user.save
      user.employed_outlet = outlet
      user.employed_customer = current_user.customer
      render json: { staff_id: user.id }, status: :created
    else
      if user.errors.messages.has_key?(:email)
        user.errors.messages[:username] = user.errors.messages.delete(:email)
      end
      render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
    end
  end

end
