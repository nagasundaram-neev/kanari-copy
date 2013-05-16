class RedemptionsController < ApplicationController
  before_action :set_redemption, only: [:show, :edit, :update, :destroy]

  # GET /redemptions
  # GET /redemptions.json
  def index
    @redemptions = Redemption.all
  end

  # GET /redemptions/1
  # GET /redemptions/1.json
  def show
  end

  # GET /redemptions/new
  def new
    @redemption = Redemption.new
  end

  # GET /redemptions/1/edit
  def edit
  end

  # POST /redemptions
  # POST /redemptions.json
  def create
    @redemption = Redemption.new(redemption_params)

    respond_to do |format|
      if @redemption.save
        format.html { redirect_to @redemption, notice: 'Redemption was successfully created.' }
        format.json { render action: 'show', status: :created, location: @redemption }
      else
        format.html { render action: 'new' }
        format.json { render json: @redemption.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /redemptions/1
  # PATCH/PUT /redemptions/1.json
  def update
    respond_to do |format|
      if @redemption.update(redemption_params)
        format.html { redirect_to @redemption, notice: 'Redemption was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @redemption.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /redemptions/1
  # DELETE /redemptions/1.json
  def destroy
    @redemption.destroy
    respond_to do |format|
      format.html { redirect_to redemptions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_redemption
      @redemption = Redemption.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def redemption_params
      params.require(:redemption).permit(:user_id, :outlet_id, :points)
    end
end
