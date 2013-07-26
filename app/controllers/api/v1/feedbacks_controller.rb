class Api::V1::FeedbacksController < ApplicationController
  before_action :authenticate_user!, only: [:index, :metrics]
  before_action :set_feedback, only: [:show, :edit, :update, :destroy]
  before_action :set_outlet, only: [:index, :metrics]

  respond_to :json

  # GET /feedbacks
  # GET /feedbacks.json
  def index
    authorize! :read_feedbacks, @outlet
    @feedbacks = @outlet.get_feedbacks(params)
    render json: @feedbacks
  end

  def metrics
    authorize! :read_feedbacks, @outlet
    @feedback_insights = @outlet.insights(params)
    render json: @feedback_insights.to_json
  end

  # PATCH/PUT /feedbacks/1
  # PATCH/PUT /feedbacks/1.json
  def update
    current_user = warden.authenticate(scope: :user)
    render json: {errors: ["Feedback not found."]}, status: :not_found and return if @feedback.nil?
    expiry_time = GlobalSetting.where(setting_name: 'feedback_expiry_time').first.setting_value.to_i

    render json: {errors: ["Sorry, time for giving feedback has been expired! You were supposed to give feedback within #{expiry_time} minutes"]}, status: :unprocessable_entity and return if((Time.zone.now - @feedback.created_at ) > expiry_time.minutes)
    if current_user.nil?
      if @feedback.update(feedback_params)
        @feedback.code = nil; @feedback.completed = true
        @feedback.save
        render json: {points: @feedback.points}, status: :ok
      else
        render json: {errors: @feedback.errors.full_messages}, status: :unprocessable_entity
      end
    else
      Feedback.transaction do
        authorize! :create, Feedback
        points = @feedback.points
        outlet = @feedback.outlet
        outlet.add_points_to_rewards_poll(points)
        current_user.update_points_and_feedbacks_count(points)
        @feedback.rewards_pool_after_feedback = outlet.rewards_pool
        @feedback.user_points_after_feedback  = current_user.points_available
        @feedback.user = current_user
        @feedback.code = nil
        @feedback.completed = true
        if @feedback.update(feedback_params)
          render json: {points: @feedback.points}, status: :ok
        else
          render json: {errors: @feedback.errors.full_messages}, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /feedbacks/1
  # DELETE /feedbacks/1.json
  def destroy
    @feedback.destroy
    respond_to do |format|
      format.html { redirect_to feedbacks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feedback
      @feedback = Feedback.where(id: params[:id]).first
    end

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

    # Never trust parameters from the scary internet, only allow the white list through.
    def feedback_params
      params.require(:feedback).permit(:food_quality, :speed_of_service, :friendliness_of_service, :ambience, :cleanliness, :value_for_money, :comment, :recommendation_rating)
    end
end
