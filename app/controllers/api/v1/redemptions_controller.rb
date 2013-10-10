class Api::V1::RedemptionsController < ApplicationController

  before_action :authenticate_user!

  respond_to :json

  def index
    outlet = nil
    if params[:outlet_id].present?
      outlet = Outlet.find(params[:outlet_id])
    else
      outlet = current_user.outlets.first
    end
    render json: {errors: ["Outlet not found."]}, status: :not_found and return if outlet.nil?
    authorize! :read_all_redemptions, outlet
    @redemptions = outlet.get_redemptions(params)
    render json: @redemptions
  end

  def create
    authorize! :request, Redemption
    redemption = Redemption.new(redemption_params)
    redemption.user_id = current_user.id
    outlet = redemption.outlet
    if outlet.blank?
      render json: {errors: ["Outlet not found."]}, status: :not_found and return
    end
    if !redemption.points_available?
      render json: {errors: ["Points not available"]}, status: :unprocessable_entity and return
    end
    if redemption.save
      current_user.last_activity_at = Time.zone.now
      current_user.save!
      render json: nil, status: :created
    else
      render json: {errors: redemption.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /redemptions/1
  # PATCH/PUT /redemptions/1.json
  def update
    redemption = Redemption.where(id: params[:id], approved_by: nil).first
    render json: {errors: ["Redemption request not found"]}, status: :not_found and return if redemption.nil?
    outlet = redemption.outlet
    authorize! :approve_redemptions, outlet
    expiry_time = GlobalSetting.where(setting_name: 'redemption_expiry_time').first.setting_value.to_i rescue 30
    render json: {errors: ["Redemption request expired"]}, status: :unprocessable_entity and return if((Time.zone.now - redemption.created_at ) > expiry_time.minutes)
    user = redemption.user
    points = redemption.points

    if params[:redemption][:approve] && params[:redemption][:approve] == true
    # Approve redemption
      render json: {errors: ["Outlet doesn't have enough rewards points."]}, status: :unprocessable_entity and return if(outlet.rewards_pool < points)
      render json: {errors: ["User doesn't have enough points."]}, status: :unprocessable_entity and return if(user.points_available < points)
      Redemption.transaction do
        outlet_points_before = outlet.rewards_pool
        user_points_before =   user.points_available
        outlet.update_rewards_and_redeem_points(points)
        user.update_points_and_redeems_count(points)
        redemption_parameters = { approved_by: current_user.id, approved_at: Time.zone.now, rewards_pool_after_redemption: outlet.rewards_pool,
                                  user_points_after_redemption: user.points_available }
        unless user.interacted_before?(outlet)
          redemption.first_interaction = true
        end
        if redemption.update(redemption_parameters)
          RedemptionLog.create({customer_id: outlet.customer_id, outlet_id: outlet.id, outlet_name: outlet.name,
            generated_by: current_user.email, user_id: user.id, user_first_name: user.first_name, user_last_name: user.last_name,
            user_email: user.email, points: points, outlet_points_before: outlet_points_before, outlet_points_after: outlet.rewards_pool,
            user_points_before: user_points_before, user_points_after: user.points_available, redemption_id: redemption.id })
          render json: nil, status: :ok
        else
          render json: redemption.errors, status: :unprocessable_entity
        end
      end
    else
    # Update redemption
      if redemption.update(redemption_params)
        render json: nil, status: :ok
      else
        render json: redemption.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /redemptions/1
  # DELETE /redemptions/1.json
  def destroy
    @redemption.destroy
    respond_to do |format|
      format.html { redirect_to redemptions_url }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def redemption_params
    params.require(:redemption).permit(:outlet_id, :points)
  end
end
