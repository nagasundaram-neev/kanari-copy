require 'normalize_time'
require 'dashboard_summary'
class Outlet < ActiveRecord::Base
  include NormalizeTime

  # Net Promoter Score, is based on last 100 records
  # TODO: Make it outlet specific
  NPS_LIMIT = 100

  default_scope -> {  where(disabled: false) }
  belongs_to :customer, inverse_of: :outlets
  has_many :feedbacks, inverse_of: :outlet
  has_many :redemptions, inverse_of: :outlet
  belongs_to :manager, -> { where role: 'manager'}, class_name: 'User'
  has_many :outlets_cuisine_types
  has_many :cuisine_types, through: :outlets_cuisine_types
  has_many :outlets_outlet_types
  has_many :outlet_types, through: :outlets_outlet_types
  has_many :outlets_staffs
  has_many :staffs, through: :outlets_staffs
  has_many :payment_invoices, inverse_of: :outlet

  def redeemable_points
    rewards_pool - points_pending_redemption
  end

  def points_pending_redemption
    redemptions.pending.sum(:points)
  end

  def get_feedbacks params
    if params[:type] && params[:type] == "pending"
      get_pending_feedbacks
    else
      start_time, end_time = normalize_start_and_end_time(params[:start_time], params[:end_time])
      get_completed_feedbacks(start_time, end_time)
    end
  end

  def get_redemptions(params)
    if params[:type] && params[:type] == "pending"
      get_pending_redemptions
    else
      start_time, end_time = normalize_start_and_end_time(params[:start_time], params[:end_time])
      get_processed_redemptions(start_time, end_time)
    end
  end

  def trends(options={})
    start_time = normalize_date(options[:start_time]) || self.created_at
    end_time   = normalize_date(options[:end_time]) || Time.zone.now

    #TODO: Instead of trying to guess what the user inteded, we should raise an exception
    start_time,end_time = end_time,start_time if start_time > end_time

    #TODO: Lazily evaluate the query. Do not fetch all completed feedbacks here.
    # First construct the query with the time range and then fire the query.
    feedbacks   = self.feedbacks.completed.includes(:user)
    redemptions = self.redemptions.approved.includes(:user)
    feedback_trends = {:statistics => {}, :summary => {}, :detailed_statistics => {}}
    feedback_trends[:statistics] = get_feedback_trends(start_time, end_time, feedbacks, redemptions)
    feedback_trends[:summary] = get_feedback_summary(start_time, end_time, feedbacks, redemptions)

    ((start_time.to_date)..(end_time.to_date)).each do |day|
      day_start = day.beginning_of_day; day_end = day.end_of_day
      feedback_trends[:detailed_statistics][day.strftime("%Y-%m-%d")] = get_feedback_trends(day_start, day_end, feedbacks, redemptions)
    end

    return {:feedback_trends => feedback_trends}
  end

  def insights(params={})
    today     = normalize_date(params[:date]) || Time.zone.now.beginning_of_day
    tomorrow  = today + 1.day
    yesterday = today - 1.day
    feedbacks_till_today     = self.feedbacks.completed.where("updated_at < ?", tomorrow).order('updated_at desc').limit(NPS_LIMIT)
    feedbacks_till_yesterday = self.feedbacks.completed.where("updated_at < ?", today).order('updated_at desc').limit(NPS_LIMIT)
    feedbacks_today          = feedbacks_till_today.select{|f| (f.updated_at >= today && f.updated_at < tomorrow)}
    feedbacks_yesterday      = feedbacks_till_today.select{|f| (f.updated_at >= yesterday && f.updated_at < today)}
    feedback_metrics = {
      :food_quality               =>  {:like => 0, :dislike => 0, :neutral => 0, :change => 0},
      :speed_of_service           =>  {:like => 0, :dislike => 0, :neutral => 0, :change => 0},
      :friendliness_of_service    =>  {:like => 0, :dislike => 0, :neutral => 0, :change => 0},
      :ambience                   =>  {:like => 0, :dislike => 0, :neutral => 0, :change => 0},
      :cleanliness                =>  {:like => 0, :dislike => 0, :neutral => 0, :change => 0},
      :value_for_money            =>  {:like => 0, :dislike => 0, :neutral => 0, :change => 0},
      :net_promoter_score         =>  {:like => 0, :dislike => 0, :neutral => 0, :change => 0},
      :feedbacks_count            =>  feedbacks_today.length,
      :rewards_pool               =>  self.rewards_pool
    }

    unless feedbacks_till_today.blank?
      feedback_metrics[:net_promoter_score] = get_net_promoter_score(feedbacks_till_yesterday, feedbacks_till_today)
      ["food_quality", "speed_of_service", "friendliness_of_service", "ambience", "cleanliness", "value_for_money"].each do |category|
        feedback_metrics[category.to_sym] = get_field_metrics(feedbacks_yesterday, feedbacks_today, category)
      end
    end

    return {:feedback_insights => feedback_metrics}
  end

  def add_points_to_rewards_pool(points)
    self.with_lock do
      self.rewards_pool = self.rewards_pool.to_i + points
      self.save
    end
  end

  def update_rewards_and_redeem_points(points)
    self.with_lock do
      self.rewards_pool    = self.rewards_pool.to_i - points
      self.points_redeemed = self.points_redeemed.to_i + points
      self.save
    end
  end

  private

    def get_net_promoter_score(feedbacks_till_yesterday, feedbacks_till_today)
      promoters_till_today = 0; passives_till_today = 0; net_promoters_till_yesterday = 0; 
      net_promoters_till_today = 0; neutrals_till_yesterday = 0; neutrals_till_today = 0
      if feedbacks_till_yesterday.present?
        promoters_till_yesterday = (feedbacks_till_yesterday.select{|f| AppConfig[:promoters].include?f.recommendation_rating }.length.to_f / feedbacks_till_yesterday.length) * 100
        passives_till_yesterday  = (feedbacks_till_yesterday.select{|f| AppConfig[:detractors].include?f.recommendation_rating }.length.to_f / feedbacks_till_yesterday.length) * 100
        neutrals_till_yesterday  = 100 - ( promoters_till_yesterday + passives_till_yesterday )
        net_promoters_till_yesterday = promoters_till_yesterday - passives_till_yesterday
      end
      if feedbacks_till_today.present?
        promoters_till_today = (feedbacks_till_today.select{|f| AppConfig[:promoters].include?f.recommendation_rating }.length.to_f / feedbacks_till_today.length) * 100
        passives_till_today  = (feedbacks_till_today.select{|f| AppConfig[:detractors].include?f.recommendation_rating }.length.to_f / feedbacks_till_today.length)* 100
        neutrals_till_today  = 100 - ( promoters_till_today + passives_till_today )
        net_promoters_till_today = promoters_till_today - passives_till_today
      end
      {:like => promoters_till_today, :dislike => passives_till_today, :neutral => neutrals_till_today, :change => net_promoters_till_today - net_promoters_till_yesterday}
    end

    def get_field_metrics(feedbacks_yesterday, feedbacks_today, type)
      promoters_today = 0; passives_today = 0; net_promoters_yesterday = 0; 
      net_promoters_today = 0; neutrals_yesterday = 0; neutrals_today = 0
      if feedbacks_yesterday.present?
        promoters_yesterday = (feedbacks_yesterday.select{|f| AppConfig[:liked]    == f.send(type) }.length.to_f / feedbacks_yesterday.length) * 100
        passives_yesterday  = (feedbacks_yesterday.select{|f| AppConfig[:disliked] == f.send(type) }.length.to_f / feedbacks_yesterday.length) * 100
        neutrals_yesterday  = 100 - ( promoters_yesterday + passives_yesterday )
        net_promoters_yesterday = promoters_yesterday - passives_yesterday
      end
      if feedbacks_today.present?
        promoters_today = (feedbacks_today.select{|f| AppConfig[:liked]    == f.send(type) }.length.to_f / feedbacks_today.length) * 100
        passives_today  = (feedbacks_today.select{|f| AppConfig[:disliked] == f.send(type) }.length.to_f / feedbacks_today.length) * 100
        neutrals_today  = 100 - ( promoters_today + passives_today )
        net_promoters_today = promoters_today - passives_today
      end
      {:like => promoters_today, :dislike => passives_today, :neutral => neutrals_today, :change => (net_promoters_today - net_promoters_yesterday)}
    end

    def get_pending_feedbacks
      self.feedbacks.pending.order("updated_at desc")
    end

    def get_completed_feedbacks(start_time, end_time)
      self.feedbacks.completed.where({updated_at: start_time..end_time}).order("updated_at desc")
    end

    def get_pending_redemptions
      self.redemptions.pending.order("updated_at desc")
    end

    def get_processed_redemptions(start_time, end_time)
      self.redemptions.processed.where({updated_at: start_time..end_time}).order("updated_at desc")
    end

    # Feedback Statistics
    def get_feedback_trends(start_time, end_time, all_feedbacks, all_redemptions)
      start_time,end_time = end_time,start_time if start_time > end_time
      all_feedbacks = all_feedbacks.order('feedbacks.updated_at desc') unless all_feedbacks.blank?
      feedbacks_nps  = all_feedbacks.select {|f| f if (f.updated_at < end_time)}.first(NPS_LIMIT)
      feedbacks      = all_feedbacks.select {|f| f if (f.updated_at > start_time && f.updated_at < end_time)}
      redemptions    = all_redemptions.select {|f| f if (f.updated_at > start_time && f.updated_at < end_time)}
      statistics     = {}
      statistics[:net_promoter_score] = get_net_promoter_score_statistics(feedbacks_nps)
      ["food_quality", "speed_of_service", "friendliness_of_service", "ambience", "cleanliness", "value_for_money"].each do |category|
        statistics[category.to_sym] = get_field_statistics(feedbacks, category)
      end
      statistics[:usage]               = get_usage_statistics(feedbacks, redemptions)
      statistics[:customers]           = get_cusomers_statistics(feedbacks)
      statistics[:average_bill_amount] = get_average_bill_amount_statistics(feedbacks)
      statistics
    end

    def get_field_statistics(feedbacks,type)
      promoters = 0; passives = 0; neutrals = 0
      unless feedbacks.blank?
        promoters = feedbacks.select{|f| AppConfig[:liked]    == f.send(type) }.length
        passives  = feedbacks.select{|f| AppConfig[:disliked] == f.send(type) }.length
        neutrals  = feedbacks.length - ( promoters + passives )
      end
      {:like => promoters, :dislike => passives, :neutral => neutrals}
    end

    def get_net_promoter_score_statistics(feedbacks)
      promoters = 0; passives = 0; neutrals = 0
      if feedbacks.present?
        promoters = (feedbacks.select{|f| AppConfig[:promoters].include?f.recommendation_rating }.length.to_f / feedbacks.length) * 100
        passives  = (feedbacks.select{|f| AppConfig[:detractors].include?f.recommendation_rating }.length.to_f / feedbacks.length)* 100
        neutrals  = 100 - ( promoters + passives )
      end
      nps = {:like => promoters, :dislike => passives, :neutral => neutrals}
    end

    def get_average_bill_amount_statistics(feedbacks)
      #TODO: Why to_i ? This will steal decimals from the bill amount.
      feedbacks.present? ? ( feedbacks.inject(0){|sum, f| sum + f.bill_amount.to_i}.to_f / feedbacks.length ) : 0
    end

    def get_cusomers_statistics(feedbacks)
      male_users = 0; female_users = 0; new_users = 0; returning_users = 0
      time_of_visit = { "0" => 0, "1" => 0, "2" => 0, "3" => 0,  "4" => 0,  "5" => 0,  "6" => 0,
                        "7" => 0, "8" => 0, "9" => 0, "10" => 0, "11" => 0, "12" => 0, "13" => 0,
                        "14" => 0, "15" => 0, "16" => 0, "17" => 0, "18" => 0, "19" => 0, "20" => 0,
                        "21" => 0, "22" => 0, "23" => 0 }
      unless feedbacks.blank?
        users = []
        feedbacks.each {|f| users << f.user }
        users = users.compact
        male_users      = users.select {|user| user if user.gender && user.gender.to_s.downcase == 'male'}.length
        female_users    = users.select {|user| user if user.gender && user.gender.to_s.downcase == 'female'}.length
        new_users       = users.select {|user| user if user.sign_in_count == 0 }.length
        returning_users = users.select {|user| user if user.sign_in_count > 0 }.length
        feedbacks_per_hour = feedbacks.group_by {|f| f.updated_at.strftime('%H')}
        ("00".."23").each {|hr| time_of_visit["#{hr.to_i}"] = ( feedbacks_per_hour["#{hr}"] && feedbacks_per_hour["#{hr}"].length) || 0 }
      end
      customer = {:male => male_users, :female => female_users, :new_users => new_users, :returning_users => returning_users, :time_of_visit => time_of_visit} 
   end

    def get_usage_statistics(feedbacks=[],redemptions=[])
      usage =  { :feedbacks_count => 0, :redemptions_count => 0, :discounts_claimed => 0, :points_issued => 0, :rewards_pool => 0 }
      unless feedbacks.blank?
        usage[:feedbacks_count] = feedbacks.length
        feedbacks_with_user = feedbacks.select{|f| !([0, nil].include?f.user_id) }
        usage[:points_issued] = feedbacks_with_user.inject(0){|sum, f| sum + f.points.to_i}
      end 
      unless redemptions.blank?
        usage[:redemptions_count] = redemptions.length
        usage[:discounts_claimed] = redemptions.inject(0){|sum, r| sum + r.points.to_i}
      end

      #TODO: Refactor ! This will be inefficient when the array is huge.
      latest = (feedbacks | redemptions).compact.uniq.sort! {|i,j| i.updated_at <=> j.updated_at}.last
      rewards_pool = latest ? latest.send("rewards_pool_after_#{latest.class.name.downcase}") : 0 
      usage[:rewards_pool] = rewards_pool
      usage
    end

    def get_feedback_summary(start_time, end_time, all_feedbacks, all_redemptions)
      summary_calculator = DashboardSummary.new(start_time, end_time, all_feedbacks, all_redemptions)
      summary     = {}
      summary[:customer_experience] = summary_calculator.get_customer_experience_summary
      summary[:net_promoter_score] = summary_calculator.get_net_promoter_score_summary
      summary[:feedback_submissions] = summary_calculator.get_feedback_submission_summary
      summary[:redemptions_processed] = summary_calculator.get_redemptions_count_summary
      summary[:demographics] = summary_calculator.get_demographics_summary
      summary[:users] = summary_calculator.get_users_summary
      summary[:average_bill_size] = summary_calculator.get_average_bill_size_summary
      summary[:average_rewards_pool_size] = summary_calculator.get_rewards_pool_summary
      summary[:discounts_claimed] = summary_calculator.get_discounts_claimed_summary
      summary[:points_issued] = summary_calculator.get_points_issued_summary
      return summary
    end

end
