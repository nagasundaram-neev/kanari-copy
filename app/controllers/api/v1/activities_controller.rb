class Api::V1::ActivitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.role == 'user'
      activities = current_user.activities
      results = {:activities => activities}
      render json: results.to_json, status: :ok
    else
      render json: {errors: ["Insufficient privileges"]}, status: :forbidden
    end
  end
end
