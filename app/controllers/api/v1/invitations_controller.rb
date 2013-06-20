class Api::V1::InvitationsController < ApplicationController

  respond_to :json

  # GET /invitations/(:invitation_token)
  def show
    user = User.where(invitation_token: params[:invitation_token]).first
    if user.nil?
      render json: {errors: ["Invalid invitation token"]}, status: :unprocessable_entity
    else
      render json: {email: user.email}, status: :ok
    end
  end

end
