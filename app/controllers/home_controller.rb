class HomeController < ApplicationController
  include AbstractController::Layouts
  layout 'application'
  def index
    render 'index'
  end
end
