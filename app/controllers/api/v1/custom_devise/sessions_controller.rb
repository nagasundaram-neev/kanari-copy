module Api
  module V1
    module CustomDevise
      class SessionsController < Devise::SessionsController
        prepend_before_filter :require_no_authentication, :only => [:create ]
        skip_before_filter :skip_trackable, :only => [:create]

        include Devise::Controllers::Helpers

        respond_to :json

        def create
          self.resource = warden.authenticate!(auth_options)
          render json: {errors: ["Inactive User"]}, status: :unprocessable_entity and return unless resource.is_active?
          sign_in(resource_name, resource)
          resource.reset_authentication_token!
          resource.save!
          if resource.role == 'customer_admin'
            render json: { auth_token: resource.authentication_token, first_name: resource.first_name, last_name: resource.last_name,
              user_role: resource.role, sign_in_count: resource.sign_in_count, registration_complete: resource.registration_complete?,
              customer_id: (resource.customer.nil? ? nil : resource.customer.id), can_create_new_outlet: resource.can_create_new_outlet? }
          else
            render json: { auth_token: resource.authentication_token, first_name: resource.first_name, last_name: resource.last_name,
              user_role: resource.role, sign_in_count: resource.sign_in_count, registration_complete: resource.registration_complete?,
              customer_id: (resource.customer.nil? ? nil : resource.customer.id) }
          end
        end

        def destroy
          authenticate_user!(force: true)
          current_user.reset_authentication_token!
          sign_out(resource_name)
        end

      end
    end
  end
end
