class Api::V1::FeedbacksController < ApplicationController
  before_action :authenticate_user!, only: [:index, :metrics, :trends ,:user_reachout]
  before_action :set_feedback, only: [:show, :edit, :destroy , :user_reachout]
  before_action :set_outlet, only: [:index, :metrics, :trends]

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

  def trends
    authorize! :read_trends, @outlet
    @feedback_trends = @outlet.trends(params)
    render json: @feedback_trends.to_json
  end

  # PATCH/PUT /feedbacks/1
  # PATCH/PUT /feedbacks/1.json
  def update
    current_user = warden.authenticate(scope: :user)
    set_feedback_for_update
    render json: {errors: ["Feedback not found."]}, status: :not_found and return if @feedback.nil?
    expiry_time = GlobalSetting.where(setting_name: 'feedback_expiry_time').first.setting_value.to_i

    render json: {errors: ["Code expired"]}, status: :unprocessable_entity and return if((Time.zone.now - @feedback.created_at ) > expiry_time.minutes)
    if current_user.nil?
      if @feedback.update(feedback_params)
        @feedback.completed = true
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
        outlet_points_before = outlet.rewards_pool
        user_points_before = current_user.points_available
        code_before = @feedback.code
        outlet.add_points_to_rewards_pool(points)
        current_user.update_points_and_feedbacks_count(points)
        @feedback.rewards_pool_after_feedback = outlet.rewards_pool
        @feedback.user_points_after_feedback  = current_user.points_available
        @feedback.user = current_user
        @feedback.code = nil
        @feedback.completed = true
        unless current_user.interacted_before?(outlet)
          @feedback.first_interaction = true
        end
        if @feedback.update(feedback_params)
          FeedbackLog.create({customer_id: outlet.customer_id, outlet_id: outlet.id, outlet_name: outlet.name, feedback_id: @feedback.id,
              user_id: current_user.id, user_first_name: current_user.first_name, user_last_name: current_user.last_name, user_email: current_user.email,
              code: code_before, points: @feedback.points, outlet_points_before: outlet_points_before, outlet_points_after: outlet.rewards_pool,
              user_points_before: user_points_before, user_points_after: current_user.points_available })
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

  # Customer Admin / Manager can send email asking whether they can reach out to them or not
  def user_reachout
    # Authorize resource
    authorize! :get_feedback, @feedback.outlet
    # Update the feedback status only when feedback permission
    begin
      if @feedback.completed && @feedback.user_status == "reach_out" && @feedback.user.present?
        #sending mail with parameters user feedback and the admin user(manager or customer_admin)
        UserMailer.request_email_to_share_details(@feedback.user, @feedback, current_user).deliver
        if(@feedback.update_column("user_status","pending"))
          render json: {response: "pending" }, status: :ok
        else
          render json: {errors: @feedback.errors.full_messages}, status: :unprocessable_entity
        end
      else
        render json: {errors: ["Data not sufficient."]}, status: :unprocessable_entity
      end
    rescue => e
      render json: {errors: e}, status: :unprocessable_entity
    end
  end

  # Customer Admin / Manager can communicate by sending email once the user gives the response ok
  def user_response
    @feedback = Feedback.where("id = ? and user_id = ? and user_status = ? and completed = ?",params[:feed_id],params[:send_id], "pending", true).first
    render json: {errors: ["Feedback not found."]}, status: :not_found and return if @feedback.nil?
    @contacted_user = User.where("id = ?", params["contacted_user_id"]).first
    render json: {errors: ["User not found."]}, status: :not_found and return if @contacted_user.nil?

    begin
      if params["response"] == "1"
        #sending mail with parameters user feedback and the admin user(manager or customer_admin)
        UserMailer.customer_accepted_email_to_share_details(@feedback,@contacted_user).deliver
        status = "accepted"
      elsif params["response"] == "0"
         status = "rejected"
      else
        render json: {errors: ["Invalid response"]}, status: :unprocessable_entity and return
      end
      if(@feedback.update_column("user_status", status))
        render json: {response: status }, status: :ok
      else
        render json: {errors: @feedback.errors.full_messages}, status: :unprocessable_entity
      end
    rescue => e
      render json: {errors: e}, status: :unprocessable_entity
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_feedback
    @feedback = Feedback.where(id: params[:id]).first
  end

  def set_feedback_for_update
    if params[:feedback][:user_id].nil?
      set_incomplete_feedback
    else
      set_completed_feedback
    end
  end

  def set_completed_feedback
    @feedback = Feedback.where(id: params[:id], completed: true).first
  end

  def set_incomplete_feedback
    @feedback = Feedback.where(id: params[:id], completed: false).first
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
