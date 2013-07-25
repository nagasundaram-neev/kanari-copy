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
  
  #PUT /staffs/1
  def update
    staff = User.staff.where(id: params[:id]).first
    render json: {errors: ["Staff record not found"]}, status: :not_found and return if staff.blank?
    authorize! :update, staff 
    if(staff.employed_customer != current_user.customer)
      render json: {errors: ["Insufficient privileges"]}, status: :forbidden and return
    end
    if staff.update_with_password(update_staff_params)
      render json: nil, status: :ok
    else
      render json: {errors: staff.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    staff = User.where(role: 'staff', id: params[:id]).first
    render json: {errors: ["Staff record not found"]}, status: :not_found and return if staff.blank?
    outlet = staff.employed_outlet
    render json: {errors: ["Outlet not found"]}, status: :not_found and return if outlet.blank?
    authorize! :delete_staff, outlet
    if staff.destroy
      render json: nil, status: :ok
    else
      render json: {errors: staff.errors.full_messages}, status: :unprocessable_entity
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
    last_staff = User.staff.last
    if last_staff.blank?
      "000001"
    else
      last_tablet_id = User.staff.last.email.split('@').first.to_i
      next_tablet_id = last_tablet_id + 1
      if(next_tablet_id.to_s.length == 6)
        next_tablet_id.to_s
      else
        ( "0" * (6 - next_tablet_id.to_s.length) ) + next_tablet_id.to_s
      end
    end
  end

  def update_staff_params
    params.fetch(:staff).permit([:password, :password_confirmation, :current_password])
  end
end
