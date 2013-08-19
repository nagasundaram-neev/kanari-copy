class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::StrongParameters
  include CanCan::ControllerAdditions

  before_filter :skip_trackable

  #Use skip_before_filter :skip_trackable :only => [:method_name]
  #to track user log in
  def skip_trackable
    request.env['devise.skip_trackable'] = true
  end

  #Handle authorization exception from CanCan
  rescue_from CanCan::AccessDenied do |exception|
    render json: {errors: ["Insufficient privileges"]}, status: :forbidden
  end

  #Handle RecordNotFound errors
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {errors: [exception.message]}, status: :unprocessable_entity
  end

end
