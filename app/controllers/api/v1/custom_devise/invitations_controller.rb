module Api
  module V1
    module CustomDevise

      class InvitationsController < Devise::InvitationsController

        prepend_before_filter :authenticate_inviter!, :only => [:create]
        prepend_before_filter :require_no_authentication, :only => [:update, :destroy]

        # POST /resource/invitation
        def create
          self.resource = resource_class.invite!(invite_params, current_inviter) do
            skip_invitation = true
          end
          resource.invitation_sent_at = Time.now.utc
          resource.save
          if resource.errors.empty?
            render json: {invitation_token: resource.invitation_token}, status: 201 #Invitation created
          else
            render json: {errors: resource.errors.full_messages}, status: 422 #Unprocessable entity
          end
        end

        # PUT /resource/invitation
        # params : invitation_token, password, password_confirmation
        def update
          self.resource = resource_class.accept_invitation!(update_resource_params)
          if resource.errors.empty?
            auth_token = resource.reset_authentication_token
            resource.save
          end
          if resource.errors.empty?
            sign_in(resource_name, resource)
            render json: {auth_token: auth_token}, status: 200 #Invitation accepted
          else
            render json: {errors: resource.errors.full_messages}, status: 422 #Unprocessable entity
          end
        end

        # GET /resource/invitation/remove?invitation_token=abcdef
        def destroy
          resource.destroy
        end

        protected
        def current_inviter
          @current_inviter ||= authenticate_inviter!
        end

        def resource_from_invitation_token
          unless params[:invitation_token] && self.resource = resource_class.to_adapter.find_first(params.slice(:invitation_token))
            set_flash_message(:alert, :invitation_token_invalid)
            redirect_to after_sign_out_path_for(resource_name)
            render json: {errors: [t(:invitation_token_invalid)]}, status: 422
          end
        end

        def invite_params
          devise_parameter_sanitizer.for(:invite)
        end

        def update_resource_params
          params.fetch(:user).permit([:password, :password_confirmation, :invitation_token, :name])
        end
      end

    end
  end
end

