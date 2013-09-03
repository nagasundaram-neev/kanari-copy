class Api::V1::AuditLogsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :read, :audit_logs
    outlet = Outlet.where(id: params[:outlet_id]).first
    render json: {errors: ["Outlet not found"]}, status: :not_found and return if outlet.nil?
    type = params[:type]
    render json: {errors: ["Type missing"]}, status: :not_found and return if type.blank?
    unless ["feedback", "code_generation", "redemption"].include?(type)
      render json: {errors: ["Type invalid"]}, status: :unprocessable_entity and return
    end
    audit_log  = params[:type].to_s + "_log"
    audit_logs = audit_log.camelize.constantize.get_audit_logs(params)
    render json: audit_logs, status: :ok
  end
end
