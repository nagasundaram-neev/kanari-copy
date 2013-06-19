class Api::V1::RedemptionsController < ApplicationController

  before_action :authenticate_user!

  respond_to :json


  def create
    authorize! :request, Redemption
    redemption = Redemption.new(redemption_params)
    redemption.user_id = current_user.id

    if !redemption.points_available?
      render json: {errors: ["Points not available"]}, status: :unprocessable_entity and return
    end

    if redemption.save
      current_user.points_available -= redemption.points
      current_user.save
      render json: nil, status: :created
    else
      render json: {errors: redemption.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /redemptions/1
  # PATCH/PUT /redemptions/1.json
  def update
    respond_to do |format|
      if @redemption.update(redemption_params)
        format.html { redirect_to @redemption, notice: 'Redemption was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @redemption.errors, status: :unprocessable_entity }
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
