class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  before_filter :skip_trackable

  #Use skip_before_filter :skip_trackable :only => [:method_name]
  #to track user log in
  def skip_trackable
    request.env['devise.skip_trackable'] = true
  end

end
