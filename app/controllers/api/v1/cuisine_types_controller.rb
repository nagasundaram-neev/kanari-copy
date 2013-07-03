class Api::V1::CuisineTypesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  # GET /cuisine_types
  def index
    render json: CuisineType.all
  end

  def show
    render json: CuisineType.find(params[:id])
  end

  def create
    cuisine_type = CuisineType.new(cuisine_params)
    authorize! :create, CuisineType
    if cuisine_type.save
      render json: cuisine_type, status: :created
    else
      render json: {errors: cuisine_type.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update
    authorize! :create, CuisineType
    cuisine_type = CuisineType.find(params[:id])
    if cuisine_type.update(cuisine_params)
      render json: nil
    else
      render json: {errors: cuisine_type.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :create, CuisineType
    CuisineType.destroy(params[:id])
    render json: nil
  end

  private

    def cuisine_params
      params.fetch(:cuisine_type).permit([:name])
    end

end
