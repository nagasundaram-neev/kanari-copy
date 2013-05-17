module Api
  module V1
    module CustomDevise
      class SessionsController < Devise::SessionsController
        prepend_before_filter :require_no_authentication, :only => [:create ]
        include Devise::Controllers::Helpers

        respond_to :json

        def create
          self.resource = warden.authenticate!(auth_options)
          sign_in(resource_name, resource)
          resource.reset_authentication_token!
          resource.save!
          render json: {
            auth_token: resource.reset_authentication_token,
            user_role: resource.role
          }
          return
          invalid_login_attempt
        rescue
          invalid_login_attempt
        end

        def destroy
          sign_out(resource_name)
        end

        protected

          def invalid_login_attempt
            warden.custom_failure!
            render :json=> { errors: ["Invalid login credentials"] }, :status=>401
          end
      end
    end
  end
end
