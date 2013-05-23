module Api
  module V1
    module CustomDevise
      class PasswordsController < Devise::PasswordsController
        append_before_filter :assert_reset_token_passed, :only => :update
        include Devise::Controllers::Helpers

        respond_to :json

        # POST /users/password
        def create
          self.resource = resource_class.send_reset_password_instructions(resource_params)
        end


        # PUT /resource/password
        def update
          self.resource = resource_class.reset_password_by_token(resource_params)

          if resource.errors.empty?
            resource.unlock_access! if unlockable?(resource)
            resource.reset_authentication_token!
            sign_in(resource_name, resource)
            render json: {
              auth_token: resource.authentication_token,
              user_role: resource.role
            }
          end
        end

        protected

          # Check if a reset_password_token is provided in the request
          def assert_reset_token_passed
            if params[:reset_password_token].blank?
              render json: {errors: ["reset_password_token missing"]}, status: 400
            end
          end

      end
    end
  end
end
