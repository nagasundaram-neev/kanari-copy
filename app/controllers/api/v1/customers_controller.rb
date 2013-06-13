class Api::V1::CustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer, only: [:update, :destroy]

  respond_to :json

  # GET /customers
  # GET /customers.json
  def index
    if current_user.role == 'customer_admin'
      render json: current_user.customer and return
    else
      customers = Customer.all
      authorize! :read_all, Customer
      render json: customers and return
    end
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
    customer = Customer.find(params[:id])
    authorize! :read, customer
    render json: customer
  end

  # POST /customers
  # POST /customers.json
  def create
    authorize! :create, Customer
    @customer = Customer.new(customer_params)
    @customer.customer_admin = current_user

    if @customer.save
      render json: nil, status: :created
    else
      render json: @customer.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    authorize! :update, @customer
    if @customer.update(customer_params)
      render json: nil, status: 200
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(
        :name, :phone_number, :email,
        :registered_address_line_1, :registered_address_line_2, :registered_address_city, :registered_address_country,
        :mailing_address_line_1, :mailing_address_line_2, :mailing_address_city, :mailing_address_country
      )
    end
end
