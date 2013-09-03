require 'normalize_time'
class CodeGenerationLog < ActiveRecord::Base
extend NormalizeTime

  def self.get_audit_logs(params)
    outlet_id = params[:outlet_id]
    return [] if outlet_id.blank?
    start_time, end_time = normalize_start_and_end_time(params[:start_time], params[:end_time])
    where(created_at: (start_time..end_time), outlet_id: outlet_id)
  end

end
