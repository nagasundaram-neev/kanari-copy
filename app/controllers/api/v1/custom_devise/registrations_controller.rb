module Api
  module V1
    module CustomDevise
      class RegistrationsController < Devise::RegistrationsController
        prepend_before_filter :require_no_authentication, :only => [ :create, :cancel ]
        prepend_before_filter :authenticate_scope!, :only => [:update, :destroy]

        respond_to :json

        # POST /resource
        def create
          self.resource = build_resource(sign_up_params)

          resource.role = 'user'
          resource.reset_authentication_token

          if resource.save
            if resource.active_for_authentication?
              sign_up(resource_name, resource)
              render json: {
                auth_token: resource.authentication_token,
                user_role: resource.role,
                registration_complete: resource.registration_complete?
              }, status: :created
            else
              render json: {errors: [resource.inactive_message]}, status: :created
            end
          else
            clean_up_passwords resource
            render json: {errors: resource.errors.full_messages}, status: :unprocessable_entity
          end
        end

        # PUT /resource
        # We need to use a copy of the resource because we don't want to change
        # the current user in place.
        def update
          self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
          prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
          resource.reset_authentication_token
          if resource.update_with_password(account_update_params)
            sign_in resource_name, resource, :bypass => true
            render json: {
              auth_token: resource.authentication_token,
              user_role: resource.role,
              registration_complete: resource.registration_complete?
            }, status: :ok
          else
            clean_up_passwords resource
            render json: {errors: resource.errors.full_messages}, status: :unprocessable_entity
          end
        end

        # DELETE /resource
        def destroy
          resource.destroy
          Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
          render json: nil, status: 200
        end
        private
          def sign_up_params
            params.fetch(:user).permit([:password, :password_confirmation, :email, :first_name, :last_name, :phone_number])
          end

          def account_update_params
            params.fetch(:user).permit([:password, :password_confirmation, :email, :first_name, :last_name, :current_password, :date_of_birth, :gender, :location, :phone_number])
          end
      end
    end
  end
end
