class CodeGenerationLogSerializer < ActiveModel::Serializer
  attributes :id, :outlet_id, :outlet_name, :customer_id, :feedback_id, :tablet_id, :code, :bill_size, :created_at

  def tablet_id
    object.generated_by && object.generated_by.split('@').first.to_s
  end

end
