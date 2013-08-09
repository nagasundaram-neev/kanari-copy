desc "Delete a)incomplete feedbacks, b)kanari codes from feedbacks which are greater than the feedback_expiry_time."
#This task should ideally be started around 3 hours post breakfast, lunch and dinner, that seems to be the best time
#to recycle codes.
task :feedback_cleanup => :environment do
  feedback_expiry_time = GlobalSetting.where(setting_name: 'feedback_expiry_time').first.setting_value rescue 120

  feedbacks_older_than_expiry_time = Feedback.where("created_at < ?", 120.minutes.ago)

  feedbacks_with_kanari_code = feedbacks_older_than_expiry_time.where('code IS NOT NULL')
  feedbacks_with_kanari_code.update_all(code: nil)

  incomplete_feedbacks = feedbacks_older_than_expiry_time.where(completed: false)
  incomplete_feedbacks.delete_all
end
