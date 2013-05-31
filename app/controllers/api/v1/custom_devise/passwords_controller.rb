module Api
  module V1
    module CustomDevise
      class PasswordsController < Devise::PasswordsController
        append_before_filter :assert_reset_token_passed, :only => []
        include Devise::Controllers::Helpers

        respond_to :json

        # POST /users/password
        def create
          self.resource = resource_class.send_reset_password_instructions(resource_params)
        end

        def edit
          redirect_to "/#/api/users/password/edit?reset_password_token=#{params[:reset_password_token]}"
        end


        # PUT /users/password
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
          else
            render json: {errors: resource.errors.full_messages}, status: 422 #Unprocessable entity
          end
        end

      end
    end
  end
end
