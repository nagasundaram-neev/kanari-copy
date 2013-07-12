class Outlet < ActiveRecord::Base

  # Net Promoter Score, is based on last 100 records
  # TODO: Make it outlet specific
  NPS_LIMIT = 100

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

  def redeemable_points
    rewards_pool - points_pending_redemption
  end

  def points_pending_redemption
    redemptions.where(approved_by: nil).sum(:points)
  end
  
  def pending_redemptions
    redemptions.where({approved_by: nil})
  end

  def get_feedbacks params
    start_time = normalize_date(params[:start_time]) || self.created_at
    end_time   = normalize_date(params[:end_time]) || Time.zone.now
    self.feedbacks.completed.where({updated_at: start_time..end_time}).order("updated_at desc")
  end

  def insights params={}
    today     = normalize_date(params[:date]) || Date.today
    yesterday = today - 1.day
    tomorrow  = today + 1.day

    feedbacks_till_today     = self.feedbacks.completed.where("updated_at <= ?", tomorrow).limit(NPS_LIMIT)
    feedbacks_till_yesterday = self.feedbacks.completed.where("updated_at <= ?", yesterday).limit(NPS_LIMIT)
    feedbacks_today          = feedbacks_till_today.select{|f| (f.updated_at.to_date == today)}
    feedbacks_yesterday      = feedbacks_till_today.select{|f| (f.updated_at.to_date == yesterday)}

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


  private

    def normalize_date date
      DateTime.parse(date) rescue nil
    end

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
      {:like => promoters_till_today.to_i, :dislike => passives_till_today.to_i, :neutral => neutrals_till_today.to_i, :change => (net_promoters_till_today - net_promoters_till_yesterday).to_i}
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
      {:like => promoters_today.to_i, :dislike => passives_today.to_i, :neutral => neutrals_today.to_i, :change => (net_promoters_today - net_promoters_yesterday).to_i}
    end

end

