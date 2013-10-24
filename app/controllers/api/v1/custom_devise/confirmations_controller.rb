module Api
  module V1
    module CustomDevise
      class ConfirmationsController < Devise::ConfirmationsController
        respond_to :json

        def new
          render json: nil, status: 404 #Route not used
        end

        def redirect
          redirect_to "/#/api/users/confirmations?confirmation_token=#{params[:confirmation_token]}"
        end

        # POST /resource/confirmation
        def create
          self.resource = resource_class.send_confirmation_instructions(resource_params)
          if resource.errors.empty?
            render json: nil, status: :ok #Confirmation mail sent
          else
            render json: {errors: resource.errors.full_messages}, status: :unprocessable_entity #Unprocessable entity
          end
        end

        # GET /resource/confirmation?confirmation_token=abcdef
        def show
          self.resource = resource_class.confirm_by_token(params[:confirmation_token])

          if resource.errors.empty?
            auth_token = resource.reset_authentication_token
            resource.save
          end
          if resource.errors.empty?
            render json: nil, status: 200 #User confirmed
          else
            render json: {errors: resource.errors.full_messages}, status: 422 #Unprocessable entity
          end
        end


      end
    end
  end
end
