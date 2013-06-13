class Api::V1::UsersController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  # GET /outlet_types
  def index
    render json: current_user, status: :ok
  end

end
