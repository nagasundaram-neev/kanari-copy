desc "Update feedbacks user_status which are greater than the feedback_reachout_expiry_time(72 hours) from current time."
#This task will be run once in a day at 12.00 AM.
task :reset_feedback_user_status => :environment do

  feedbacks_older_than_expiry_time = Feedback.where("completed = ? and user_status = ? and created_at < ?", true, "pending", AppConfig[:feedback_reachout_expiry_time].to_i.hours.ago)

  feedbacks_older_than_expiry_time.update_all(user_status: "reach_out") if !feedbacks_older_than_expiry_time.empty?

end