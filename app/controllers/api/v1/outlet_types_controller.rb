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

  def create
    outlet_type = OutletType.new(outlet_params)
    authorize! :create, OutletType
    if outlet_type.save
      render json: outlet_type, status: :created
    else
      render json: {errors: outlet_type.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update
    authorize! :create, OutletType
    outlet_type = OutletType.find(params[:id])
    if outlet_type.update(outlet_params)
      render json: nil
    else
      render json: {errors: outlet_type.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

    def outlet_params
      params.fetch(:outlet_type).permit([:name])
    end

end
