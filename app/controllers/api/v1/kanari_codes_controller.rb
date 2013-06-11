class Api::V1::KanariCodesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  # GET /kanari_codes/:code
  def show
    Feedback.where(code: params[:code])
  end

  def create
    outlet = nil
    if params[:outlet_id]
      outlet = Outlet.find(params[:outlet_id])
    else
      outlet = current_user.outlets.first
    end
    if outlet.nil?
      render json: {errors: ["Outlet not found"]}, status: :unprocessable_entity and return
    end
    authorize! :generate_code, outlet
    points = rounded_ten_percentage_of(params[:bill_amount])
    code = random_five_digit_number
    feedback = Feedback.new(code: code, points: points, outlet: outlet, generated_by: current_user, completed: false)
    if feedback.save
      render json: {code: code}, status: :created
    else
      render json: {errors: feedback.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

    def rounded_ten_percentage_of(value)
      (value * 0.1).round
    end

    def random_five_digit_number
      rand(10 ** 5).to_s.rjust(5,'0')
    end

end
