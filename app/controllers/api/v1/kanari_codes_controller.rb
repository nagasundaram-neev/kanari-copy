class Api::V1::KanariCodesController < ApplicationController
  before_filter :authenticate_user!, except: [:show]

  respond_to :json

  # GET /kanari_codes/:code
  def show
    feedback = Feedback.where(code: params[:id]).first
    if feedback.nil?
      render json: {errors: ["Invalid code"]}, status: :unprocessable_entity
    else
      render json: {feedback_id: feedback.id, outlet_name: feedback.name}, status: :ok
    end
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
    bill_amount = params[:bill_amount]
    points = rounded_ten_percentage_of(bill_amount)
    code = random_five_digit_number
    feedback = Feedback.new(code: code, bill_amount: bill_amount, points: points, outlet: outlet, generated_by: current_user, completed: false)
    if feedback.save
      CodeGenerationLog.create({customer_id: outlet.customer_id, outlet_id: outlet.id, outlet_name: outlet.name, feedback_id: feedback.id,
                                generated_by: current_user.id, code: code, bill_size: bill_amount, status: feedback.completed  })
      render json: {code: code}, status: :created
    else
      render json: {errors: feedback.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

    def rounded_ten_percentage_of(value)
      (value * 0.1).floor
    end

    def random_five_digit_number
      rand(10 ** 5).to_s.rjust(5,'0')
    end

end
