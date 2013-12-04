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


          if successful_signup?(resource)
            render json: {
              auth_token: resource.authentication_token,
              first_name: resource.first_name,
              last_name: resource.last_name,
              user_role: resource.role,
              sign_in_count: resource.sign_in_count,
              registration_complete: resource.registration_complete?
            }, status: :created
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

          updated = if needs_password?(resource, params)
            resource.update_with_password(account_update_params)
          else
            params[:user].delete(:current_password)
            resource.update_without_password(account_update_params)
          end

          if updated
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
            params.fetch(:user).permit([:password, :password_confirmation, :email, :first_name, :last_name, :phone_number, :gender, :date_of_birth])
          end

          def account_update_params
            params.fetch(:user).permit([:email, :password, :password_confirmation, :first_name, :last_name, :current_password, :date_of_birth, :gender, :location, :phone_number])
          end

          def needs_password?(user, params)
            (params[:user][:email].present? && (user.email != params[:user][:email])) || params[:user][:password].present?
          end

          def set_random_password
            random_password = Devise.friendly_token[0,20]
            resource.password = resource.password_confirmation = random_password
          end

          def oauth_signup?
            params[:oauth_provider].present?
          end

          def successful_signup?(resource)
            if oauth_signup?
              unless SocialNetworkAccount.valid_access_token?(params[:oauth_provider], params[:access_token])
                resource.errors.add(:access_token, 'is invalid')
                return false #Invalid access_token
              end
              existing_resource = resource_class.where(email: resource.email).first
              if existing_resource.present?
                existing_resource.reset_authentication_token
                existing_resource.save
                if existing_oauth_provider = SocialNetworkAccount.where(provider: params[:oauth_provider], user: existing_resource).first
                  existing_oauth_provider.access_token = params[:access_token]
                  existing_oauth_provider.save
                  #User exists and oauth provider has been linked with already
                else
                  existing_resource.social_network_accounts << SocialNetworkAccount.new(provider: params[:oauth_provider], access_token: params[:access_token])
                  #User exists but a new oauth provider is linked
                end
                self.resource = existing_resource
                return true
              else
                resource.social_network_accounts << SocialNetworkAccount.new(provider: params[:oauth_provider], access_token: params[:access_token])
                set_random_password
                resource.skip_invitation = true
                resource.skip_confirmation! #No need to confirm invited users
                return resource.save #User is created and oauth provider is added
              end
            else
              resource.skip_invitation = true
              resource.skip_confirmation! #No need to confirm invited users
              return resource.save #Has nothing to do with oauth
            end
          end
      end
    end
  end
end
