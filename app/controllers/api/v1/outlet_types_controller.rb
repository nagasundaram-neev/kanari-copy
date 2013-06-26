class Api::V1::OutletTypesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  # GET /outlet_types
  def index
    render json: OutletType.all
  end

  def show
    render json: OutletType.find(params[:id])
  end

end
