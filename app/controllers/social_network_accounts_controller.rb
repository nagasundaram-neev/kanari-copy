class SocialNetworkAccountsController < ApplicationController
  before_action :set_social_network_account, only: [:show, :edit, :update, :destroy]

  # GET /social_network_accounts
  # GET /social_network_accounts.json
  def index
    @social_network_accounts = SocialNetworkAccount.all
  end

  # GET /social_network_accounts/1
  # GET /social_network_accounts/1.json
  def show
  end

  # GET /social_network_accounts/new
  def new
    @social_network_account = SocialNetworkAccount.new
  end

  # GET /social_network_accounts/1/edit
  def edit
  end

  # POST /social_network_accounts
  # POST /social_network_accounts.json
  def create
    @social_network_account = SocialNetworkAccount.new(social_network_account_params)

    respond_to do |format|
      if @social_network_account.save
        format.html { redirect_to @social_network_account, notice: 'Social network account was successfully created.' }
        format.json { render action: 'show', status: :created, location: @social_network_account }
      else
        format.html { render action: 'new' }
        format.json { render json: @social_network_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /social_network_accounts/1
  # PATCH/PUT /social_network_accounts/1.json
  def update
    respond_to do |format|
      if @social_network_account.update(social_network_account_params)
        format.html { redirect_to @social_network_account, notice: 'Social network account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @social_network_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /social_network_accounts/1
  # DELETE /social_network_accounts/1.json
  def destroy
    @social_network_account.destroy
    respond_to do |format|
      format.html { redirect_to social_network_accounts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_social_network_account
      @social_network_account = SocialNetworkAccount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def social_network_account_params
      params.require(:social_network_account).permit(:access_token, :access_secret, :refresh_token, :provider, :user_id)
    end
end
