class DashboardSummary

  def initialize(start_time, end_time, all_feedbacks, all_redemptions)
    start_time,end_time = end_time,start_time if start_time > end_time
    @start_time = start_time
    @end_time = end_time
    @feedbacks      = all_feedbacks.select {|f| f if (f.updated_at > start_time && f.updated_at < end_time)}
    @redemptions    = all_redemptions.select {|f| f if (f.updated_at > start_time && f.updated_at < end_time)}

    @previous_end_time = @start_time
    @previous_start_time = @previous_end_time - (@end_time - @start_time)
    @previous_feedbacks      = all_feedbacks.select {|f| f if (f.updated_at > @previous_start_time && f.updated_at < @previous_end_time)}
    @previous_redemptions    = all_redemptions.select {|f| f if (f.updated_at > @previous_start_time && f.updated_at < @previous_end_time)}
  end

  def get_customer_experience_summary
    customer_experience = {}
    [:food_quality, :speed_of_service, :friendliness_of_service, :ambience, :cleanliness, :value_for_money].each do |category|
      customer_experience[category] = get_category_summary(category)
    end
    return customer_experience
  end

  def get_net_promoter_score_summary
    current_promoters = @feedbacks.select{|f| AppConfig[:promoters].include?f.recommendation_rating }.length
    current_detractors = @feedbacks.select{|f| AppConfig[:detractors].include?f.recommendation_rating }.length
    current_passives = @feedbacks.size - (current_promoters + current_detractors)

    previous_promoters = @previous_feedbacks.select{|f| AppConfig[:promoters].include?f.recommendation_rating }.length
    previous_detractors = @previous_feedbacks.select{|f| AppConfig[:detractors].include?f.recommendation_rating }.length
    previous_passives = @previous_feedbacks.size - (previous_promoters + previous_detractors)

    current_score = percentage(current_promoters - current_passives,@feedbacks.size)
    previous_score = percentage(previous_promoters - previous_passives,@previous_feedbacks.size)

    current_promoters_percent = percentage(current_promoters,@feedbacks.size)
    previous_promoters_percent = percentage(previous_promoters,@previous_feedbacks.size)
    current_detractors_percent = percentage(current_detractors,@feedbacks.size)
    previous_detractors_percent = percentage(previous_detractors,@previous_feedbacks.size)
    current_passives_percent = percentage(current_passives,@feedbacks.size)
    previous_passives_percent = percentage(previous_passives,@previous_feedbacks.size)

    return {
      score: {
        over_period: current_score,
        change_in_points: point_change(previous_score, current_score)
      },
      feedbacks_count: {
        over_period: @feedbacks.size,
        change_in_percentage: percentage_change(@previous_feedbacks.size, @feedbacks.size)
      },
      promoters: {
        over_period: current_promoters_percent,
        change_in_points: point_change(previous_promoters_percent, current_promoters_percent)
      },
      detractors: {
        over_period: current_detractors_percent,
        change_in_points: point_change(previous_detractors_percent, current_detractors_percent)
      },
      passives: {
        over_period: current_passives_percent,
        change_in_points: point_change(previous_passives_percent, current_passives_percent)
      }
    }
  end

  def get_feedbacks_count_summary
    current_feedback_count = @feedbacks.size
    previous_feedback_count = @previous_feedbacks.size
    average_feedbacks_per_day = current_feedback_count.to_f/((@end_time.to_date - @start_time.to_date).round)

    return ({
      over_period: current_feedback_count,
      average_per_day: average_feedbacks_per_day,
      change_in_percentage: percentage_change(previous_feedback_count, current_feedback_count)
    })
  end

  def get_redemptions_count_summary
    current_redemptions_count = @redemptions.size
    previous_redemptions_count = @previous_redemptions.size
    average_redemptions_per_day = current_redemptions_count.to_f/((@end_time.to_date - @start_time.to_date).round)

    return ({
      over_period: current_redemptions_count,
      average_per_day: average_redemptions_per_day,
      change_in_percentage: percentage_change(previous_redemptions_count, current_redemptions_count)
    })
  end

  def get_rewards_pool_summary

    #TODO: Refactor ! This will be inefficient when the array is huge.
    latest = (@feedbacks | @redemptions).compact.uniq.sort! {|i,j| i.updated_at <=> j.updated_at}.last
    rewards_pool = latest ? latest.send("rewards_pool_after_#{latest.class.name.downcase}") : 0

    latest = (@previous_feedbacks | @previous_redemptions).compact.uniq.sort! {|i,j| i.updated_at <=> j.updated_at}.last
    previous_rewards_pool = latest ? latest.send("rewards_pool_after_#{latest.class.name.downcase}") : 0
    return ({
      over_period: rewards_pool,
      change_in_percentage: percentage_change(previous_rewards_pool, rewards_pool)
    })
  end

  def get_demographics_summary
    @users ||= get_users(@feedbacks)
    current_male_users = @users.select {|user| user if user.gender && user.gender.to_s.downcase == 'male'}.length
    current_male_percentage = percentage(current_male_users,@users.size)
    current_female_percentage = (100.0 - current_male_percentage) rescue nil

    @previous_users ||= get_users(@previous_feedbacks)
    previous_male_users = @previous_users.select {|user| user if user.gender && user.gender.to_s.downcase == 'male'}.length
    previous_male_percentage = percentage(previous_male_users,@previous_users.size)
    previous_female_percentage = (100.0 - previous_male_percentage) rescue nil

    return ({
      male:{
        over_period: current_male_percentage,
        change_in_points: point_change(previous_male_percentage, current_male_percentage)
      },
      female:{
        over_period: current_female_percentage,
        change_in_points: point_change(previous_female_percentage, current_female_percentage)
      }
    })

  end

  def get_users_summary
    @users ||= get_users(@feedbacks)
    current_new_users       = @users.select {|user| user if user.sign_in_count == 0 }.length
    current_returning_users = @users.select {|user| user if user.sign_in_count > 0 }.length

    @previous_users ||= get_users(@previous_feedbacks)
    previous_new_users       = @previous_users.select {|user| user if user.sign_in_count == 0 }.length
    previous_returning_users = @previous_users.select {|user| user if user.sign_in_count > 0 }.length

    return({
      new_users:{
        over_period: current_new_users,
        average_per_day: current_new_users.to_f/((@end_time.to_date - @start_time.to_date).round),
        change_in_percentage: percentage_change(previous_new_users, current_new_users)
      },
      returning_users:{
        over_period: current_returning_users,
        average_per_day: current_returning_users.to_f/((@end_time.to_date - @start_time.to_date).round),
        change_in_percentage: percentage_change(previous_returning_users, current_returning_users)
      }
    })

  end

  def get_average_bill_size_summary
    current_average_bill = get_average_bill_size(@feedbacks)
    previous_average_bill = get_average_bill_size(@previous_feedbacks)
    return({
      over_period: current_average_bill,
      change_in_percentage: percentage_change(previous_average_bill, current_average_bill)
    })
  end

  private

    def get_category_summary(category)
      previous_likes = @previous_feedbacks.select{|f| AppConfig[:liked] == f.send(category) }.length
      previous_likes_percentage = percentage(previous_likes,@previous_feedbacks.size)
      current_likes = @feedbacks.select{|f| AppConfig[:liked] == f.send(category) }.length
      current_likes_percentage = percentage(current_likes,@feedbacks.size)

      previous_dislikes = @previous_feedbacks.select{|f| AppConfig[:disliked] == f.send(category) }.length
      previous_dislikes_percentage = percentage(previous_dislikes,@previous_feedbacks.size)
      current_dislikes = @feedbacks.select{|f| AppConfig[:disliked] == f.send(category) }.length
      current_dislikes_percentage = percentage(current_dislikes,@feedbacks.size)

      previous_neutrals = @previous_feedbacks.size - (previous_likes + previous_dislikes)
      previous_neutrals_percentage = percentage(previous_neutrals,@previous_feedbacks.size)
      current_neutrals = @feedbacks.size - (current_likes + current_dislikes)
      current_neutrals_percentage = percentage(current_neutrals,@feedbacks.size)
      return ({
          like: {
            over_period: current_likes_percentage,
            change_in_points: point_change(previous_likes_percentage, current_likes_percentage)
          },
          dislike: {
            over_period: current_dislikes_percentage,
            change_in_points: point_change(previous_dislikes_percentage, current_dislikes_percentage)
          },
          neutral: {
            over_period: current_neutrals_percentage,
            change_in_points: point_change(previous_neutrals_percentage, current_neutrals_percentage)
          }
      })
    end

    def get_users(feedbacks)
      users = []
      feedbacks.each {|f| users << f.user }
      users.compact.uniq
    end

    def percentage_change(old_value, new_value)
      return nil if old_value == 0
      ((new_value - old_value).to_f/old_value)*100
    end

    def point_change(old_value, new_value)
      (new_value - old_value) rescue nil
    end

    def percentage(numerator,denominator)
      return nil if denominator == 0
      (numerator.to_f/denominator)*100
    end

    def get_average_bill_size(feedbacks)
      feedbacks.present? ? ( feedbacks.inject(0){|sum, f| sum + f.bill_amount.to_f} / feedbacks.length ) : 0.0
    end
end
