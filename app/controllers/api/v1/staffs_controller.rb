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
    if params[:user][:outlet_id].present?
      @outlet = Outlet.where(id: params[:user][:outlet_id].to_s.strip).first
    else
      @outlet = current_user.outlets.first
    end
    if @outlet.nil?
      render json: {errors: ["Outlet not found"]}, status: :not_found and return
    end
    authorize! :create_staff, @outlet
    username = get_next_tablet_id
    #email = params[:user][:email].nil? ? "#{username}@kanari.co" : params[:user][:email]
    email = "#{username}@kanari.co"
    user = User.new(email: email, password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
    user.role = "staff"
    if user.save
      user.employed_outlet = @outlet
      user.employed_customer = current_user.customer
      tablet_id = user.email.split('@')[0]
      render json: { staff_id: user.id, tablet_id: tablet_id }, status: :created
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
      render json: {errors: ["Outlet not found"]}, status: :not_found and return
    end
  end

  def get_next_tablet_id
    latest = User.staff.pluck('email').collect{|staff| staff.split('@').first.to_i}.max
    latest.blank? ? 000001 : (latest + 1)
  end
end
