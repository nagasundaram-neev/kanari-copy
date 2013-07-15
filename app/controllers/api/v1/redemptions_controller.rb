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
    if outlet.nil?
      render json: {errors: ["Outlet not found"]}, status: :unprocessable_entity and return
    end
    if params[:type] && params[:type] == 'pending'
      authorize! :read_pending_redemptions, outlet
      @redemptions = outlet.pending_redemptions
    else
      authorize! :read_all_redemptions, outlet
      @redemptions = outlet.redemptions
    end
    render json: @redemptions
  end

  def create
    authorize! :request, Redemption
    redemption = Redemption.new(redemption_params)
    redemption.user_id = current_user.id
    outlet = redemption.outlet

    if outlet.blank?
      render json: {errors: ["Outlet is not available"]}, status: :unprocessable_entity and return
    end

    if !redemption.points_available?
      render json: {errors: ["Points not available"]}, status: :unprocessable_entity and return
    end

    Redemption.transaction do
      if redemption.save
        current_user.points_available -= redemption.points
        current_user.save
        render json: nil, status: :created
      else
        render json: {errors: redemption.errors.full_messages}, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /redemptions/1
  # PATCH/PUT /redemptions/1.json
  def update
    redemption = Redemption.where(id: params[:id], approved_by: nil).first
    if redemption.nil?
      render json: {errors: ["User has already redeemed reward points."]}, status: :unprocessable_entity and return
    end
    outlet = redemption.outlet
    authorize! :approve_redemptions, outlet
    user = redemption.user
    points = redemption.points

    if params[:redemption][:approve]
    # Approve redemption
      if outlet.rewards_pool > points
        Redemption.transaction do 
          outlet.with_lock do
            outlet.rewards_pool = outlet.rewards_pool.to_i - points
            outlet.points_redeemed = outlet.points_redeemed.to_i + points
            outlet.save
          end
          user.with_lock do
            user.points_redeemed = user.points_redeemed.to_i + points
            user.save
          end
          redemption_parameters = { approved_by: current_user.id, 
                                    rewards_pool_after_redemption: outlet.rewards_pool, 
                                    user_points_after_redemption: user.points_available }

          if redemption.update(redemption_parameters)
            render json: nil, status: :ok
          else
            render json: redemption.errors, status: :unprocessable_entity
          end
        end
      else
        render json: {errors: ["Outlet doesn't have enough rewards points."]}, status: :unprocessable_entity
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
