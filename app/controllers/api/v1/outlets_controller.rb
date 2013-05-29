class Api::V1::OutletsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_outlet, only: [:show, :update, :destroy]

  respond_to :json

  # GET /outlets
  # GET /outlets.json
  def index
    @outlets = Outlet.all
  end

  # GET /outlets/1
  # GET /outlets/1.json
  def show
  end

  # POST /outlets
  def create
    @outlet = Outlet.new(outlet_params)
    authorize! :create, @outlet

    @outlet.customer = current_user.customer
    if @outlet.save
      render json: @outlet, status: :created
    else
      render json: @outlet.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /outlets/1
  # PATCH/PUT /outlets/1.json
  def update
    respond_to do |format|
      if @outlet.update(outlet_params)
        format.html { redirect_to @outlet, notice: 'Outlet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @outlet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /outlets/1
  # DELETE /outlets/1.json
  def destroy
    @outlet.destroy
    respond_to do |format|
      format.html { redirect_to outlets_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_outlet
      @outlet = Outlet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def outlet_params
      params.require(:outlet).permit(:name, :address, :latitude, :longitude, :website_url, :email, :phone_number, :open_hours, :has_delivery, :serves_alcohol, :has_outdoor_seating)
    end
end
