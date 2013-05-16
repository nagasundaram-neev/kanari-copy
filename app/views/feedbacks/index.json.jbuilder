json.array!(@feedbacks) do |feedback|
  json.extract! feedback, :code, :score, :comment, :will_recommend, :completed, :points, :user_id, :outlet_id
  json.url feedback_url(feedback, format: :json)
end