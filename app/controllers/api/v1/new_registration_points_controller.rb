class Api::V1::NewRegistrationPointsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def create
    feedback = Feedback.completed.where("id = ? AND code IS NOT NULL AND user_id IS NULL",params[:feedback_id]).first
    render json: {errors: ["Feedback not found."]}, status: :not_found and return if feedback.nil?
    Feedback.transaction do
      authorize! :create, Feedback
      points = feedback.points
      outlet = feedback.outlet
      outlet_points_before = outlet.rewards_pool
      user_points_before = current_user.points_available
      code_before = feedback.code
      outlet.add_points_to_rewards_poll(points)
      current_user.update_points_and_feedbacks_count(points)
      feedback.user = current_user
      feedback.rewards_pool_after_feedback = outlet.rewards_pool
      feedback.user_points_after_feedback  = current_user.points_available
      feedback.code = nil
      if feedback.save
        FeedbackLog.create({customer_id: outlet.customer_id, outlet_id: outlet.id, outlet_name: outlet.name, feedback_id: feedback.id,
           user_id: current_user.id, user_first_name: current_user.first_name, user_last_name: current_user.last_name, user_email: current_user.email,
           code: code_before, points: feedback.points, outlet_points_before: outlet_points_before, outlet_points_after: outlet.rewards_pool,
           user_points_before: user_points_before, user_points_after: current_user.points_available })
        render json: {points: feedback.points}, status: :ok
      else
        render json: {errors: feedback.errors.full_messages}, status: :unprocessable_entity
      end
    end
  end

end
