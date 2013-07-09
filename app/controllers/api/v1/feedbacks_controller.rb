class Api::V1::FeedbacksController < ApplicationController
  before_action :set_feedback, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user!, only: [:index]

  respond_to :json

  # GET /feedbacks
  # GET /feedbacks.json
  def index
    if params[:outlet_id].present?
      outlet = Outlet.where(id: params[:outlet_id])
    else
      outlet = current_user.outlets.first
    end
    if outlet.nil?
      render json: {errors: ["Outlet not found"]}, status: :unprocessable_entity and return
    end

    authorize! :read_feedbacks, outlet
    @feedbacks = outlet.get_feedbacks(params)
    render json: @feedbacks
  end

  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
  end

  # GET /feedbacks/new
  def new
    @feedback = Feedback.new
  end

  # GET /feedbacks/1/edit
  def edit
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = Feedback.new(feedback_params)

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to @feedback, notice: 'Feedback was successfully created.' }
        format.json { render action: 'show', status: :created, location: @feedback }
      else
        format.html { render action: 'new' }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feedbacks/1
  # PATCH/PUT /feedbacks/1.json
  def update
    current_user = warden.authenticate(scope: :user)
    if current_user.nil?
      if @feedback.update(feedback_params)
        @feedback.code = nil
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
      @feedback = Feedback.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feedback_params
      params.require(:feedback).permit(:food_quality, :speed_of_service, :friendliness_of_service, :ambience, :cleanliness, :value_for_money, :comment, :recommendation_rating)
    end
end
