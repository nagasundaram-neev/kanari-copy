require 'spec_helper'

describe HomeController do

  describe "GET index" do
    it "should render the 'index' template with 'application' layout" do
      get :index
      response.should render_template("layouts/application")
      response.should render_template("index")
    end
  end

end
