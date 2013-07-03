require 'detect_device'
class HomeController < ApplicationController
  include AbstractController::Layouts
  include DetectDevice 
  layout :choose_layout

  def index
    render 'index'
  end

  private

  def choose_layout
    if is_mobile?(request.user_agent)
      "application_mobile"
    elsif is_tablet?(request.user_agent)
      "application_tablet"
    else
      "application"
    end
  end

end
