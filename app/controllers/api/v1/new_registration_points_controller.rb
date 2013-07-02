class Api::V1::NewRegistrationPointsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def create
    @feedback = Feedback.find(params[:feedback_id])
    Feedback.transaction do
      authorize! :create, Feedback
      points = @feedback.points
      outlet = @feedback.outlet
      outlet.with_lock do
        outlet.rewards_pool = outlet.rewards_pool + points
        @feedback.rewards_pool_after_feedback = outlet.rewards_pool
        outlet.save
      end
      current_user.with_lock do
        current_user.points_available += points
        @feedback.user_points_after_feedback += current_user.points_available
        current_user.save
      end
      @feedback.user = current_user
      if @feedback.save
        render json: {points: @feedback.points}, status: :ok
      else
        render json: {errors: @feedback.errors.full_messages}, status: :unprocessable_entity
      end
    end
  end

end
