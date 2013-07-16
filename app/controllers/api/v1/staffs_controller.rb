class Api::V1::StaffsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_outlet, only: [:index]

  respond_to :json

  def index
    authorize! :list_staff, @outlet
    @staffs = @outlet.staffs
    render json: @staffs
  end

  def create
    outlet = Outlet.find(params[:user][:outlet_id])
    authorize! :create_staff, outlet
    username = params[:user][:username]
    email = params[:user][:email].nil? ? "#{username}@kanari.co" : params[:user][:email]
    user = User.new(email: email, password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
    user.role = "staff"
    if user.save
      user.employed_outlet = outlet
      user.employed_customer = current_user.customer
      render json: { staff_id: user.id }, status: :created
    else
      if user.errors.messages.has_key?(:email) && !params[:user][:username].nil?
        user.errors.messages[:username] = user.errors.messages.delete(:email)
      end
      render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_outlet
    if params[:outlet_id].present?
      @outlet = Outlet.where(id: params[:outlet_id].strip).first
    else
      @outlet = current_user.outlets.first
    end
    if @outlet.nil?
      render json: {errors: ["Outlet not found"]}, status: :unprocessable_entity and return
    end
  end

end
