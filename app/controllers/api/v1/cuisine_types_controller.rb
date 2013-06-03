class Api::V1::CuisineTypesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  # GET /cuisine_types
  def index
    render json: CuisineType.all
  end

end
