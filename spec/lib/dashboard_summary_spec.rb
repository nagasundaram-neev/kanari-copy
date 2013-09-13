require 'spec_helper'
require 'dashboard_summary'

describe DashboardSummary do

  before(:each) do

    male_user = User.create!(email: 'test@test.com',    password: 'test1234', password_confirmation: 'test1234', gender: 'male', sign_in_count: 0)
    female_user = User.create!(email: 'test1@test.com', password: 'test1234', password_confirmation: 'test1234', gender: 'female', sign_in_count: 100)

    feedbacks = [
      Feedback.create(food_quality: 1, speed_of_service: 0,  recommendation_rating: 9,updated_at: Time.now - 11.days, user: male_user),
      Feedback.create(food_quality: 1, speed_of_service: 0,  recommendation_rating: 9,updated_at: Time.now - 10.days, user: female_user),

      Feedback.create(food_quality: 1, speed_of_service: 1,  recommendation_rating: 9,updated_at: Time.now - 9.days, user: male_user, bill_amount: 1300.70),
      Feedback.create(food_quality: 0, speed_of_service: 1,  recommendation_rating: 8,updated_at: Time.now - 8.days, user: male_user, bill_amount: 199.30),
      Feedback.create(food_quality: 0, speed_of_service: 1,  recommendation_rating: 8,updated_at: Time.now - 8.days, user: male_user),
      Feedback.create(food_quality: 1, speed_of_service: 1,  recommendation_rating: 3,updated_at: Time.now - 7.days, user: male_user),

      Feedback.create(food_quality: 1, speed_of_service: 1,  recommendation_rating: 5,updated_at: Time.now - 6.days, user: female_user, bill_amount: 100.10),
      Feedback.create(food_quality: 1, speed_of_service: -1, recommendation_rating: 8,updated_at: Time.now - 5.days, user: female_user),
      Feedback.create(food_quality: 1, speed_of_service: -1, recommendation_rating: 9,updated_at: Time.now - 5.days, user: female_user, bill_amount: 2899.90),
      Feedback.create(food_quality: 1, speed_of_service: 1,  recommendation_rating: 8,updated_at: Time.now - 4.days, rewards_pool_after_feedback: 1020, user: male_user)
    ]
    redemptions = [
      Redemption.create(updated_at: Time.now-9.days),
      Redemption.create(updated_at: Time.now-9.days),
      Redemption.create(updated_at: Time.now-8.days),
      Redemption.create(updated_at: Time.now-8.days),
      Redemption.create(updated_at: Time.now-7.days),
      Redemption.create(updated_at: Time.now-7.days, rewards_pool_after_redemption: 1000),

      Redemption.create(updated_at: Time.now-6.days),
      Redemption.create(updated_at: Time.now-5.days),
      Redemption.create(updated_at: Time.now-4.days, rewards_pool_after_redemption: 1020)
    ]
    @start_time = Time.now - (7.days - 2.hours)
    @end_time = Time.now - (4.days - 2.hours)
    @dashboard_summary = DashboardSummary.new(@start_time, @end_time, Feedback.all.to_a, Redemption.all.to_a)
  end

  describe "#get_customer_experience_summary" do
    it "should summarise likes, dislikes and neutrals over given time period and in comparison to previous time period" do
      @dashboard_summary.get_customer_experience_summary.should == {
        :food_quality =>{
          :like=>{
            :over_period=>100.0,
            :change_in_points=>50.0
          },
          :dislike=>{
            :over_period=>0.0,
            :change_in_points=>0.0
          },
          :neutral=>{
            :over_period=>0.0,
            :change_in_points=>-50.0}
        },
        :speed_of_service =>{
          :like=>{
            :over_period=> 50.0,
            :change_in_points=> -50.0
          },
          :dislike=>{
            :over_period=> 50.0,
            :change_in_points=> 50.0
          },
          :neutral=>{
            :over_period=> 0.0,
            :change_in_points=> 0.0
          }
        },
        :friendliness_of_service =>{
          :like=>{
            :over_period=>0.0,
            :change_in_points=>0.0
          },
          :dislike=>{
            :over_period=>0.0,
            :change_in_points=>0.0
          },
          :neutral=>{
            :over_period=>100.0,
            :change_in_points=>0.0
          }
        },
        :ambience =>{
          :like=>{
            :over_period=>0.0,
            :change_in_points=>0.0
          },
          :dislike=>{
            :over_period=>0.0,
            :change_in_points=>0.0
          },
          :neutral=>{
            :over_period=>100.0,
            :change_in_points=>0.0
          }
        },
        :cleanliness =>{
          :like=>{
            :over_period=>0.0,
            :change_in_points=>0.0
          },
          :dislike=>{
            :over_period=>0.0,
            :change_in_points=>0.0
          },
          :neutral=>{
            :over_period=>100.0,
            :change_in_points=>0.0
          }
        },
        :value_for_money =>{
          :like=>{
            :over_period=>0.0,
            :change_in_points=>0.0
          },
          :dislike=>{
            :over_period=>0.0,
            :change_in_points=>0.0
          },
          :neutral=>{
            :over_period=>100.0,
            :change_in_points=>0.0
          }
        }
      }
    end
  end

  describe "#get_net_promoter_score_summary" do
    it "should return the nps summary as a hash" do
      @dashboard_summary.get_net_promoter_score_summary.should == {
          score: {
          over_period: -25.0,
          change_in_points: 0.0
        },
        feedbacks_count: {
          over_period: 4,
          change_in_percentage: 0.0
        },
        promoters: {
          over_period: 25.0,
          change_in_points: 0.0
        },
        passives: {
          over_period: 50.0,
          change_in_points: 0.0
        },
        detractors: {
          over_period: 25.0,
          change_in_points: 0.0
        }

      }
    end
  end

  describe "#get_feedbacks_count_summary" do
    it "should return feedback count related summary as a hash" do
      @dashboard_summary.get_feedbacks_count_summary.should == {
        over_period: 4,
        average_per_day: 4.0/3,
        change_in_percentage: 0.0
      }
    end
  end

  describe "#get_redemptions_count_summary" do
    it "should return redemptions count related summary as a hash" do
      @dashboard_summary.get_redemptions_count_summary.should == {
        over_period: 3,
        average_per_day: 1.0,
        change_in_percentage: -50.0
      }
    end
  end

  describe "#get_rewards_pool_summary" do
    it "should return rewards pool related summary as a hash" do
      @dashboard_summary.get_rewards_pool_summary.should == {
        over_period: 1020,
        change_in_percentage: ((1020-1000).to_f/1000)*100
      }
    end
  end

  describe "#get_demographics_summary" do
    it "should return demographics related summary as a hash" do
      @dashboard_summary.get_demographics_summary.should == {
        male:{
          over_period: 50.0,
          change_in_points: -50.0
        },
        female:{
          over_period: 50.0,
          change_in_points: 50.0
        }
      }
    end
  end

  describe "#get_users_summary" do
    it "should return user related summary as a hash" do
      @dashboard_summary.get_users_summary.should == {
        new:{
          over_period: 1,
          average_per_day: 0.3333333333333333,
          change_in_percentage: 0.0
        },
        returning:{
          over_period: 1,
          average_per_day: 0.3333333333333333,
          change_in_percentage: nil
        }
      }
    end
  end

  describe "#get_average_bill_size_summary" do
    it "should return avergage bill size summary as a hash" do
      @dashboard_summary.get_average_bill_size_summary.should == {
        over_period: 750.0,
        change_in_percentage: 100.0
      }
    end
  end

end
