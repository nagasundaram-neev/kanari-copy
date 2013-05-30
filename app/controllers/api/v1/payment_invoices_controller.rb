class Api::V1::PaymentInvoicesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_payment_invoice, only: [:show, :update, :destroy]

  respond_to :json

  # GET /payment_invoices
  # GET /payment_invoices.json
  def index
    authorize! :read, PaymentInvoice
    if !set_customer
      return #Already rendered errors json
    end
    @payment_invoices = @customer.payment_invoices
    if !params[:start_date].nil? && !params[:end_date].nil?
      start_date = DateTime.parse(params[:start_date])
      end_date = DateTime.parse(params[:end_date])
      @payment_invoices = @payment_invoices.where(receipt_date: start_date..end_date)
    end
    render json: @payment_invoices
  end

  # GET /payment_invoices/1
  # GET /payment_invoices/1.json
  def show
  end

  # GET /payment_invoices/new
  def new
    @payment_invoice = PaymentInvoice.new
  end

  # GET /payment_invoices/1/edit
  def edit
  end

  # POST /payment_invoices
  # POST /payment_invoices.json
  def create
    authorize! :create, PaymentInvoice
    if !validate_customer
      return #Already rendered errors json
    end
    @payment_invoice = PaymentInvoice.new(payment_invoice_params)
    @payment_invoice.customer = @customer
    if @payment_invoice.save
      render json: nil, status: :created
    else
      render json: { errors: @payment_invoice.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /payment_invoices/1
  # PATCH/PUT /payment_invoices/1.json
  def update
    respond_to do |format|
      if @payment_invoice.update(payment_invoice_params)
        format.html { redirect_to @payment_invoice, notice: 'Payment invoice was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @payment_invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_invoices/1
  # DELETE /payment_invoices/1.json
  def destroy
    @payment_invoice.destroy
    respond_to do |format|
      format.html { redirect_to payment_invoices_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_invoice
      @payment_invoice = PaymentInvoice.find(params[:id])
    end

    def set_customer
      @customer = current_user.customer
      if @customer.nil?
        render json: {errors: ["No customer account found"]}, status: :unprocessable_entity
        return false
      else
        return true
      end
    end

    def validate_customer
      begin
        @customer = Customer.find(params[:customer_id])
      rescue
        render json: {errors: ["Invalid customer ID"]}, status: :unprocessable_entity
        return false
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_invoice_params
      params.require(:payment_invoice).permit(:kanari_invoice_id, :receipt_date, :amount_paid)
    end
end
