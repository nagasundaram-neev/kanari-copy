class HomeController < ApplicationController
  include AbstractController::Layouts
  layout :choose_layout
  def index
    render 'index'
  end

  private

    def choose_layout
      if request.user_agent =~ /Mobile|webOS/
        "application_mobile"
      else
        "application"
      end
    end
end
