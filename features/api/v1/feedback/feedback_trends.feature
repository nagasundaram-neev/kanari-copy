Feature: Dashboard Trends

    Background:
      Given I send and accept JSON

    Scenario: Customer Admin successfully gets the trends for an Outlet
      Given the following users exist
         |id        |first_name |email               | password    | authentication_token  | role            | sign_in_count  | gender  |
         |10        |Aaron      |admin@subway.com    | password123 | aaron_auth_token      | customer_admin  | 10             | male    |
         |100       |Anand      |manager@subway.com  | password123 | anand_auth_token      | manager         | 10             | male    |
         |101       |Alan       |123456@subway.com   | password123 | alan_auth_token       | staff           | 20             | male    |
         |102       |Abe        |234567@subway.com   | password123 | abe_auth_token        | staff           | 30             | male    |
         |1001      |Zahir      |zahir@gmail.com     | password123 | zahir_auth_token      | user            | 0              | male    |
         |1002      |Yusuf      |yusuf@gmail.com     | password123 | yusuf_auth_token      | user            | 1              | male    |
         |1003      |Xaviera    |xaviera@gmail.com   | password123 | xaviera_auth_token    | user            | 2              | female  |
         |1004      |Vivian     |vivian@gmail.com    | password123 | vivian_auth_token     | user            | 3              | male    |
         |1005      |Thomas     |thomas@gmail.com    | password123 | thomas_auth_token     | user            | 1              | male    |
         |1006      |Serena     |serena@gmail.com    | password123 | serena_auth_token     | user            | 0              | female  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
      And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
      And outlet "Subway - Bangalore" was created on "2013-01-01 00:00:00"
        And the outlet has "1000" points in its rewards pool
        And outlet "Subway - Bangalore" has staffs
          |123456@subway.com   |
          |234567@subway.com   |
        And the following feedbacks exist for "2013-08-01 10:10:00"
          |id  |outlet_id |user_id |points |food_quality |speed_of_service |friendliness_of_service |ambience |cleanliness |value_for_money |recommendation_rating | comment                                                                         | completed   |bill_amount  |
		      |1   |10        |1001    |400    |1            |1                |1                       |1        |1           |1               |10                     | I really enjoyed the pizza's in the out area by the street         | true        |4000         |
		      |2   |10        |1002    |100    |1            |1                |1                       |-1       |1           |1               |9                     | I am dissapointed with the service                                  | true        |1000         |
		      |3   |10        |1003    |400    |1            |1                |1                       |-1       |-1          |0               |1                     | I really enjoyed the pizza's in the out area by the street          | true        |4000         |
		      |4   |10        |1005    |100    |0            |1                |1                       |0        |-1          |-1              |9                     | I am dissapointed with the service                                  | true        |1000         |
		      |5   |10        |1006    |400    |0            |0                |1                       |0        |-1          |1               |7                     | I really enjoyed the pizza's in the out area by the street          | true        |4000         |
		      |6   |20        |3000    |100    |-1           |0                |0                       |0        |-1          |1               |6                     | I am dissapointed with the service                                  | true        |1000         |
		      |7   |10        |1002    |100    |nil          |nil              |nil                     |nil      |nil         |nil             |nil                   | nil                                                                 | false        |1000        |
        And the following feedbacks exist for "2013-08-02 08:08:00"
          |id   |outlet_id |user_id |points |food_quality |speed_of_service |friendliness_of_service |ambience |cleanliness |value_for_money |recommendation_rating | comment                                                       | completed  | bill_amount |
		      |21   |10        |1001    |50     |1            |1                |1                       |1        |1           |1               |10                     | I really enjoyed the pizza's in the out area by the street   | true       |500   |
		      |22   |10        |1002    |150    |1            |1                |1                       |-1       |1           |1               |1                     | I am dissapointed with the service                            | true       |1500  |
		      |23   |10        |1003    |200    |1            |-1               |1                       |-1       |0           |1               |2                     | I really enjoyed the pizza's in the out area by the street    | true       |2000  |
                      |24   |10        |1004    |100    |0            |-1               |0                       |-1       |0           |-1              |8                     | I am dissapointed with the service                            | true       |1000       |
		      |25   |10        |1005    |300    |-1           |0                |0                       |0        |0           |1               |7                     | I really enjoyed the pizza's in the out area by the street    | true       |3000  |
		      |26   |20        |1006    |100    |0            |0                |-1                      |0        |-1          |1               |6                     | I am dissapointed with the service                            | true       |1000  |
		      |27   |10        |nil     |300    |nil          |nil              |nil                     |nil      |nil         |nil             |nil                   | nil                                                           | false      |3000  |
        And the following redemptions exist for "2013-08-01 11:11:11"
          |id  |outlet_id |user_id |points |approved |
		      |1   |10        |1001    |400    |true     |
		      |2   |10        |1002    |100    |false    |
		      |3   |10        |1003    |400    |false    |
		      |4   |10        |1005    |100    |true     |
		      |5   |10        |1006    |400    |true     |
		      |6   |20        |3000    |100    |true     |
        And the following redemptions exist for "2013-08-02 19:10:10"
          |id   |outlet_id |user_id |points |approved |
		      |11   |10        |1001    |200    |true     |
		      |12   |10        |1002    |100    |true     |
		      |13   |10        |1003    |400    |false    |
		      |14   |10        |1005    |100    |true     |
		      |15   |20        |3000    |100    |true     |
        And the following redemptions exist for "2013-08-01 23:10:10"
          |id   |outlet_id |user_id |points |approved |rewards_pool_after_redemption|
	  |21   |10        |1001    |200    |true     |5600                         |
        And the following redemptions exist for "2013-08-02 22:10:10"
          |id   |outlet_id |user_id |points |approved |rewards_pool_after_redemption|
	  |31   |10        |1001    |200    |true     |3600                         |
      When I authenticate as the user "anand_auth_token" with the password "random string"
      And I send a GET request to "/api/feedbacks/trends" with the following:
      """
      outlet_id=10&start_time=2013-08-01 00:00:00&end_time=2013-08-02 23:59:59
      """
	  Then the response status should be "200"
      And the JSON response should be:
      """
      {
       "feedback_trends": {
         "statistics": {
           "food_quality": {
             "like"    : 6,
             "dislike" : 1,
             "neutral" : 3
           },
           "speed_of_service": {
             "like"    : 6,
             "dislike" : 2,
             "neutral" : 2
           },
           "friendliness_of_service": {
             "like"    : 8,
             "dislike" : 0,
             "neutral" : 2
           },
           "ambience": {
             "like"    : 2,
             "dislike" : 5,
             "neutral" : 3
           },
           "cleanliness": {
             "like"    : 4,
             "dislike" : 3,
             "neutral" : 3
           },
           "value_for_money": {
             "like"    : 7,
             "dislike" : 2,
             "neutral" : 1
           },
           "net_promoter_score": {
             "like"    : 40.0,
             "dislike" : 30.0,
             "neutral" : 30.0
           },
           "usage": {
             "feedbacks_count": 10,
             "redemptions_count": 8,
             "discounts_claimed": 1700,
             "points_issued": 2200,
             "rewards_pool": 3600
           },
           "customers": {
             "male": 7,
             "female": 3,
             "new_users": 3,
             "returning_users": 7,
             "time_of_visit": {"0": 0,  "1": 0,  "2": 0,  "3": 0,  "4": 0,  "5": 0,  "6": 0,  "7": 0,  "8": 5,  "9": 0,  "10": 5, "11": 0,
                               "12": 0, "13": 0, "14": 0, "15": 0, "16": 0, "17": 0, "18": 0, "19": 0, "20": 0, "21": 0, "22": 0, "23": 0}
           },
           "average_bill_amount": 2200.0
         },
         "summary": {
           "average_bill_size": {
             "change_in_percentage": null,
             "over_period": 2200.0
           },
           "customer_experience": {
             "ambience": {
               "dislike": {
                 "change_in_points": null,
                 "over_period": 50.0
               },
               "like": {
                 "change_in_points": null,
                 "over_period": 20.0
               },
               "neutral": {
                 "change_in_points": null,
                 "over_period": 30.0
               }
             },
             "cleanliness": {
               "dislike": {
                 "change_in_points": null,
                 "over_period": 30.0
               },
               "like": {
                 "change_in_points": null,
                 "over_period": 40.0
               },
               "neutral": {
                 "change_in_points": null,
                 "over_period": 30.0
               }
             },
             "food_quality": {
               "dislike": {
                 "change_in_points": null,
                 "over_period": 10.0
               },
               "like": {
                 "change_in_points": null,
                 "over_period": 60.0
               },
               "neutral": {
                 "change_in_points": null,
                 "over_period": 30.0
               }
             },
             "friendliness_of_service": {
               "dislike": {
                 "change_in_points": null,
                 "over_period": 0.0
               },
               "like": {
                 "change_in_points": null,
                 "over_period": 80.0
               },
               "neutral": {
                 "change_in_points": null,
                 "over_period": 20.0
               }
             },
             "speed_of_service": {
               "dislike": {
                 "change_in_points": null,
                 "over_period": 20.0
               },
               "like": {
                 "change_in_points": null,
                 "over_period": 60.0
               },
               "neutral": {
                 "change_in_points": null,
                 "over_period": 20.0
               }
             },
             "value_for_money": {
               "dislike": {
                 "change_in_points": null,
                 "over_period": 20.0
               },
               "like": {
                 "change_in_points": null,
                 "over_period": 70.0
               },
               "neutral": {
                 "change_in_points": null,
                 "over_period": 10.0
               }
             }
           },
           "demographics": {
             "female": {
               "change_in_points": null,
               "over_period": 33.33333333333334
             },
             "male": {
               "change_in_points": null,
               "over_period": 66.66666666666666
             }
           },
           "feedbacks_count": {
             "average_per_day": 10.0,
             "change_in_percentage": null,
             "over_period": 10
           },
           "net_promoter_score": {
             "detractors": {
               "change_in_points": null,
               "over_period": 30.0
             },
             "feedbacks_count": {
               "change_in_percentage": null,
               "over_period": 10
             },
             "passives": {
               "change_in_points": null,
               "over_period": 30.0
             },
             "promoters": {
               "change_in_points": null,
               "over_period": 40.0
             },
             "score": {
               "change_in_points": null,
               "over_period": 10.0
             }
           },
           "redemptions_count": {
             "average_per_day": 10.0,
             "change_in_percentage": null,
             "over_period": 10
           },
           "rewards_pool": {
             "change_in_percentage": null,
             "over_period": 3600
           },
           "users": {
             "new": {
               "average_per_day": 2.0,
               "change_in_percentage": null,
               "over_period": 2
             },
             "returning": {
               "average_per_day": 4.0,
               "change_in_percentage": null,
               "over_period": 4
             }
           }
         },
         "detailed_statistics": {
           "2013-08-02": {
             "food_quality": {
               "like"    : 3,
               "dislike" : 1,
               "neutral" : 1
             },
             "speed_of_service": {
               "like"    : 2,
               "dislike" : 2,
               "neutral" : 1
             },
             "friendliness_of_service": {
               "like"    : 3,
               "dislike" : 0,
               "neutral" : 2
             },
             "ambience": {
               "like"    : 1,
               "dislike" : 3,
               "neutral" : 1
             },
             "cleanliness": {
               "like"    : 2,
               "dislike" : 0,
               "neutral" : 3
             },
             "value_for_money": {
               "like"    : 4,
               "dislike" : 1,
               "neutral" : 0
             },
             "net_promoter_score": {
               "like"    : 40.0,
               "dislike" : 30.0,
               "neutral" : 30.0
             },
             "usage": {
               "feedbacks_count": 5,
               "redemptions_count": 4,
               "discounts_claimed": 600,
               "points_issued": 800,
               "rewards_pool": 3600
             },
             "customers": {
               "male": 4,
               "female": 1,
               "new_users": 1,
               "returning_users": 4,
               "time_of_visit": {"0": 0,  "1": 0,  "2": 0,  "3": 0,  "4": 0,  "5": 0,  "6": 0,  "7": 0,  "8": 5,  "9": 0,  "10": 0, "11": 0,
                                 "12": 0, "13": 0, "14": 0, "15": 0, "16": 0, "17": 0, "18": 0, "19": 0, "20": 0, "21": 0, "22": 0, "23": 0}
             },
             "average_bill_amount": 1600.0
           },
           "2013-08-01": {
             "food_quality": {
               "like"    : 3,
               "dislike" : 0,
               "neutral" : 2
             },
             "speed_of_service": {
               "like"    : 4,
               "dislike" : 0,
               "neutral" : 1
             },
             "friendliness_of_service": {
               "like"    : 5,
               "dislike" : 0,
               "neutral" : 0
             },
             "ambience": {
               "like"    : 1,
               "dislike" : 2,
               "neutral" : 2
             },
             "cleanliness": {
               "like"    : 2,
               "dislike" : 3,
               "neutral" : 0
             },
             "value_for_money": {
               "like"    : 3,
               "dislike" : 1,
               "neutral" : 1
             },
             "net_promoter_score": {
               "like"    : 60.0,
               "dislike" : 20.0,
               "neutral" : 20.0
             },
             "usage": {
               "feedbacks_count": 5,
               "redemptions_count": 4,
               "discounts_claimed": 1100,
               "points_issued": 1400,
               "rewards_pool": 5600
             },
             "customers": {
               "male": 3,
               "female": 2,
               "new_users": 2,
               "returning_users": 3,
               "time_of_visit": {"0": 0,  "1": 0,  "2": 0,  "3": 0,  "4": 0,  "5": 0,  "6": 0,  "7": 0,  "8": 0,  "9": 0,  "10": 5, "11": 0,
                                 "12": 0, "13": 0, "14": 0, "15": 0, "16": 0, "17": 0, "18": 0, "19": 0, "20": 0, "21": 0, "22": 0, "23": 0}
             },
             "average_bill_amount": 2800.0
           }
         }
       }
      }
      """

	Scenario: Customer Admin successfully gets the trends for an Outlet : There are feedbacks from Unregistered users
      Given the following users exist
         |id        |first_name |email               | password    | authentication_token  | role            | sign_in_count  | gender  |
         |10        |Aaron      |admin@subway.com    | password123 | aaron_auth_token      | customer_admin  | 10             | male    |
         |100       |Anand      |manager@subway.com  | password123 | anand_auth_token      | manager         | 10             | male    |
         |101       |Alan       |123456@subway.com   | password123 | alan_auth_token       | staff           | 20             | male    |
         |102       |Abe        |234567@subway.com   | password123 | abe_auth_token        | staff           | 30             | male    |
         |1001      |Zahir      |zahir@gmail.com     | password123 | zahir_auth_token      | user            | 0              | male    |
         |1002      |Yusuf      |yusuf@gmail.com     | password123 | yusuf_auth_token      | user            | 1              | male    |
         |1003      |Xaviera    |xaviera@gmail.com   | password123 | xaviera_auth_token    | user            | 2              | female  |
         |1004      |Vivian     |vivian@gmail.com    | password123 | vivian_auth_token     | user            | 3              | male    |
         |1005      |Thomas     |thomas@gmail.com    | password123 | thomas_auth_token     | user            | 1              | male    |
         |1006      |Serena     |serena@gmail.com    | password123 | serena_auth_token     | user            | 0              | female  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
      And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
      And outlet "Subway - Bangalore" was created on "2013-01-01 00:00:00"
        And the outlet has "1000" points in its rewards pool
        And outlet "Subway - Bangalore" has staffs
          |123456@subway.com   |
          |234567@subway.com   |
        And the following feedbacks exist for "2013-08-01 10:10:00"
          |id  |outlet_id |user_id |points |food_quality |speed_of_service |friendliness_of_service |ambience |cleanliness |value_for_money |recommendation_rating | comment                                                                         | completed   |bill_amount  |
		      |1   |10        |1001    |400    |1            |1                |1                       |1        |1           |1               |10                     | I really enjoyed the pizza's in the out area by the street         | true        |4000         |
		      |2   |10        |1002    |100    |1            |1                |1                       |-1       |1           |1               |9                     | I am dissapointed with the service                                  | true        |1000         |
		      |3   |10        |1003    |400    |1            |1                |1                       |-1       |-1          |0               |1                     | I really enjoyed the pizza's in the out area by the street          | true        |4000         |
		      |4   |10        |1005    |100    |0            |1                |1                       |0        |-1          |-1              |9                     | I am dissapointed with the service                                  | true        |1000         |
		      |5   |10        |1006    |400    |0            |0                |1                       |0        |-1          |1               |7                     | I really enjoyed the pizza's in the out area by the street          | true        |4000         |
		      |6   |10        |nil     |100    |-1           |0                |0                       |0        |-1          |1               |6                     | I am dissapointed with the service                                  | true        |1000         |
		      |7   |10        |1002    |100    |nil          |nil              |nil                     |nil      |nil         |nil             |nil                   | nil                                                                 | false        |1000        |
        And the following feedbacks exist for "2013-08-02 08:08:00"
          |id   |outlet_id |user_id |points |food_quality |speed_of_service |friendliness_of_service |ambience |cleanliness |value_for_money |recommendation_rating | comment                                                       | completed  | bill_amount |
		      |21   |10        |1001    |50     |1            |1                |1                       |1        |1           |1               |10                     | I really enjoyed the pizza's in the out area by the street   | true       |500   |
		      |22   |10        |1002    |150    |1            |1                |1                       |-1       |1           |1               |1                     | I am dissapointed with the service                            | true       |1500  |
		      |23   |10        |1003    |200    |1            |-1               |1                       |-1       |0           |1               |2                     | I really enjoyed the pizza's in the out area by the street    | true       |2000  |
                      |24   |10        |1004    |100    |0            |-1               |0                       |-1       |0           |-1              |8                     | I am dissapointed with the service                            | true       |1000       |
		      |25   |10        |1005    |300    |-1           |0                |0                       |0        |0           |1               |7                     | I really enjoyed the pizza's in the out area by the street    | true       |3000  |
		      |26   |20        |1006    |100    |0            |0                |-1                      |0        |-1          |1               |6                     | I am dissapointed with the service                            | true       |1000  |
		      |27   |10        |nil     |300    |nil          |nil              |nil                     |nil      |nil         |nil             |nil                   | nil                                                           | false      |3000  |
        And the following redemptions exist for "2013-08-01 11:11:11"
          |id  |outlet_id |user_id |points |approved |
		      |1   |10        |1001    |400    |true     |
		      |2   |10        |1002    |100    |false    |
		      |3   |10        |1003    |400    |false    |
		      |4   |10        |1005    |100    |true     |
		      |5   |10        |1006    |400    |true     |
		      |6   |20        |3000    |100    |true     |
        And the following redemptions exist for "2013-08-02 19:10:10"
          |id   |outlet_id |user_id |points |approved |
		      |11   |10        |1001    |200    |true     |
		      |12   |10        |1002    |100    |true     |
		      |13   |10        |1003    |400    |false    |
		      |14   |10        |1005    |100    |true     |
		      |15   |20        |3000    |100    |true     |
        And the following redemptions exist for "2013-08-01 23:10:10"
          |id   |outlet_id |user_id |points |approved |rewards_pool_after_redemption|
	  |21   |10        |1001    |200    |true     |5600                         |
        And the following redemptions exist for "2013-08-02 22:10:10"
          |id   |outlet_id |user_id |points |approved |rewards_pool_after_redemption|
	  |31   |10        |1001    |200    |true     |3600                         |
      When I authenticate as the user "anand_auth_token" with the password "random string"
      And I send a GET request to "/api/feedbacks/trends" with the following:
      """
      outlet_id=10&start_time=2013-08-01 00:00:00&end_time=2013-08-02 23:59:59
      """
	  Then the response status should be "200"
      And the JSON response should be:
      """
      {
       "feedback_trends": {
         "statistics": {
           "food_quality": {
             "like"    : 6,
             "dislike" : 2,
             "neutral" : 3
           },
           "speed_of_service": {
             "like"    : 6,
             "dislike" : 2,
             "neutral" : 3
           },
           "friendliness_of_service": {
             "like"    : 8,
             "dislike" : 0,
             "neutral" : 3
           },
           "ambience": {
             "like"    : 2,
             "dislike" : 5,
             "neutral" : 4
           },
           "cleanliness": {
             "like"    : 4,
             "dislike" : 4,
             "neutral" : 3
           },
           "value_for_money": {
             "like"    : 8,
             "dislike" : 2,
             "neutral" : 1
           },
           "net_promoter_score": {
             "like"    : 36.36363636363637,
             "dislike" : 36.36363636363637,
             "neutral" : 27.272727272727266
           },
           "usage": {
             "feedbacks_count": 11,
             "redemptions_count": 8,
             "discounts_claimed": 1700,
             "points_issued": 2200,
             "rewards_pool": 3600
           },
           "customers": {
             "male": 7,
             "female": 3,
             "new_users": 3,
             "returning_users": 7,
             "time_of_visit": {"0": 0,  "1": 0,  "2": 0,  "3": 0,  "4": 0,  "5": 0,  "6": 0,  "7": 0,  "8": 5,  "9": 0,  "10": 6, "11": 0,
                               "12": 0, "13": 0, "14": 0, "15": 0, "16": 0, "17": 0, "18": 0, "19": 0, "20": 0, "21": 0, "22": 0, "23": 0}
           },
           "average_bill_amount": 2090.909090909091
         },
         "summary": {
           "average_bill_size": {
             "change_in_percentage": null,
             "over_period": 2090.909090909091
           },
           "customer_experience": {
             "ambience": {
               "dislike": {
                 "change_in_points": null,
                 "over_period": 45.45454545454545
               },
               "like": {
                 "change_in_points": null,
                 "over_period": 18.181818181818183
               },
               "neutral": {
                 "change_in_points": null,
                 "over_period": 36.36363636363637
               }
             },
             "cleanliness": {
               "dislike": {
                 "change_in_points": null,
                 "over_period": 36.36363636363637
               },
               "like": {
                 "change_in_points": null,
                 "over_period": 36.36363636363637
               },
               "neutral": {
                 "change_in_points": null,
                 "over_period": 27.27272727272727
               }
             },
             "food_quality": {
               "dislike": {
                 "change_in_points": null,
                 "over_period": 18.181818181818183
               },
               "like": {
                 "change_in_points": null,
                 "over_period": 54.54545454545454
               },
               "neutral": {
                 "change_in_points": null,
                 "over_period": 27.27272727272727
               }
             },
             "friendliness_of_service": {
               "dislike": {
                 "change_in_points": null,
                 "over_period": 0.0
               },
               "like": {
                 "change_in_points": null,
                 "over_period": 72.72727272727273
               },
               "neutral": {
                 "change_in_points": null,
                 "over_period": 27.27272727272727
               }
             },
             "speed_of_service": {
               "dislike": {
                 "change_in_points": null,
                 "over_period": 18.181818181818183
               },
               "like": {
                 "change_in_points": null,
                 "over_period": 54.54545454545454
               },
               "neutral": {
                 "change_in_points": null,
                 "over_period": 27.27272727272727
               }
             },
             "value_for_money": {
               "dislike": {
                 "change_in_points": null,
                 "over_period": 18.181818181818183
               },
               "like": {
                 "change_in_points": null,
                 "over_period": 72.72727272727273
               },
               "neutral": {
                 "change_in_points": null,
                 "over_period": 9.090909090909092
               }
             }
           },
           "demographics": {
             "female": {
               "change_in_points": null,
               "over_period": 33.33333333333334
             },
             "male": {
               "change_in_points": null,
               "over_period": 66.66666666666666
             }
           },
           "feedbacks_count": {
             "average_per_day": 11.0,
             "change_in_percentage": null,
             "over_period": 11
           },
           "net_promoter_score": {
             "detractors": {
               "change_in_points": null,
               "over_period": 36.36363636363637
             },
             "feedbacks_count": {
               "change_in_percentage": null,
               "over_period": 11
             },
             "passives": {
               "change_in_points": null,
               "over_period": 27.27272727272727
             },
             "promoters": {
               "change_in_points": null,
               "over_period": 36.36363636363637
             },
             "score": {
               "change_in_points": null,
               "over_period": 9.090909090909092
             }
           },
           "redemptions_count": {
             "average_per_day": 11.0,
             "change_in_percentage": null,
             "over_period": 11
           },
           "rewards_pool": {
             "change_in_percentage": null,
             "over_period": 3600
           },
           "users": {
             "new": {
               "average_per_day": 2.0,
               "change_in_percentage": null,
               "over_period": 2
             },
             "returning": {
               "average_per_day": 4.0,
               "change_in_percentage": null,
               "over_period": 4
             }
           }
         },
         "detailed_statistics": {
           "2013-08-02": {
             "food_quality": {
               "like"    : 3,
               "dislike" : 1,
               "neutral" : 1
             },
             "speed_of_service": {
               "like"    : 2,
               "dislike" : 2,
               "neutral" : 1
             },
             "friendliness_of_service": {
               "like"    : 3,
               "dislike" : 0,
               "neutral" : 2
             },
             "ambience": {
               "like"    : 1,
               "dislike" : 3,
               "neutral" : 1
             },
             "cleanliness": {
               "like"    : 2,
               "dislike" : 0,
               "neutral" : 3
             },
             "value_for_money": {
               "like"    : 4,
               "dislike" : 1,
               "neutral" : 0
             },
             "net_promoter_score": {
               "like"    : 36.36363636363637,
               "dislike" : 36.36363636363637,
               "neutral" : 27.272727272727266
             },
             "usage": {
               "feedbacks_count": 5,
               "redemptions_count": 4,
               "discounts_claimed": 600,
               "points_issued": 800,
               "rewards_pool": 3600
             },
             "customers": {
               "male": 4,
               "female": 1,
               "new_users": 1,
               "returning_users": 4,
               "time_of_visit": {"0": 0,  "1": 0,  "2": 0,  "3": 0,  "4": 0,  "5": 0,  "6": 0,  "7": 0,  "8": 5,  "9": 0,  "10": 0, "11": 0,
                                 "12": 0, "13": 0, "14": 0, "15": 0, "16": 0, "17": 0, "18": 0, "19": 0, "20": 0, "21": 0, "22": 0, "23": 0}
             },
             "average_bill_amount": 1600.0
           },
           "2013-08-01": {
             "food_quality": {
               "like"    : 3,
               "dislike" : 1,
               "neutral" : 2
             },
             "speed_of_service": {
               "like"    : 4,
               "dislike" : 0,
               "neutral" : 2
             },
             "friendliness_of_service": {
               "like"    : 5,
               "dislike" : 0,
               "neutral" : 1
             },
             "ambience": {
               "like"    : 1,
               "dislike" : 2,
               "neutral" : 3
             },
             "cleanliness": {
               "like"    : 2,
               "dislike" : 4,
               "neutral" : 0
             },
             "value_for_money": {
               "like"    : 4,
               "dislike" : 1,
               "neutral" : 1
             },
             "net_promoter_score": {
               "like"    : 50.0,
               "dislike" : 33.33333333333333,
               "neutral" : 16.66666666666667
             },
             "usage": {
               "feedbacks_count": 6,
               "redemptions_count": 4,
               "discounts_claimed": 1100,
               "points_issued": 1400,
               "rewards_pool": 5600
             },
             "customers": {
               "male": 3,
               "female": 2,
               "new_users": 2,
               "returning_users": 3,
               "time_of_visit": {"0": 0,  "1": 0,  "2": 0,  "3": 0,  "4": 0,  "5": 0,  "6": 0,  "7": 0,  "8": 0,  "9": 0,  "10": 6, "11": 0,
                                 "12": 0, "13": 0, "14": 0, "15": 0, "16": 0, "17": 0, "18": 0, "19": 0, "20": 0, "21": 0, "22": 0, "23": 0}
             },
             "average_bill_amount": 2500.0
           }
         }
       }
      }
      """

   Scenario: Outlet doesn't have any feedbacks
      Given the following users exist
         |id        |first_name |email             | password    | authentication_token  | role            |
         |1000      |Donald     |admin@subway.com  | password123 | donald_auth_token     | customer_admin  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
	And outlet "Subway - Bangalore" was created on "2013-01-01 00:00:00"
        And the outlet doesn't have any feedback
      When I authenticate as the user "donald_auth_token" with the password "random string"
      And I send a GET request to "/api/feedbacks/trends" with the following:
      """
      outlet_id=10&start_time=2013-08-01 00:00:00&end_time=2013-08-02 23:59:59
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
       "feedback_trends": {
         "statistics": {
           "food_quality": {
             "like"    : 0,
             "dislike" : 0,
             "neutral" : 0
           },
           "speed_of_service": {
             "like"    : 0,
             "dislike" : 0,
             "neutral" : 0
           },
           "friendliness_of_service": {
             "like"    : 0,
             "dislike" : 0,
             "neutral" : 0
           },
           "ambience": {
             "like"    : 0,
             "dislike" : 0,
             "neutral" : 0
           },
           "cleanliness": {
             "like"    : 0,
             "dislike" : 0,
             "neutral" : 0
           },
           "value_for_money": {
             "like"    : 0,
             "dislike" : 0,
             "neutral" : 0
           },
           "net_promoter_score": {
             "like"    : 0,
             "dislike" : 0,
             "neutral" : 0
           },
           "usage": {
             "feedbacks_count": 0,
             "redemptions_count": 0,
             "discounts_claimed": 0,
             "points_issued": 0,
             "rewards_pool": 0
           },
           "customers": {
             "male": 0,
             "female": 0,
             "new_users": 0,
             "returning_users": 0,
             "time_of_visit": {"0": 0,  "1": 0,  "2": 0,  "3": 0,  "4": 0,  "5": 0,  "6": 0,  "7": 0,  "8": 0,  "9": 0,  "10": 0, "11": 0,
                               "12": 0, "13": 0, "14": 0, "15": 0, "16": 0, "17": 0, "18": 0, "19": 0, "20": 0, "21": 0, "22": 0, "23": 0}
           },
           "average_bill_amount": 0 
         },
         "summary": {
           "average_bill_size": {
             "change_in_percentage": null,
             "over_period": 0.0
           },
           "customer_experience": {
             "ambience": {
               "dislike": {
                 "change_in_points": null,
                 "over_period": null
               },
               "like": {
                 "change_in_points": null,
                 "over_period": null
               },
               "neutral": {
                 "change_in_points": null,
                 "over_period": null
               }
             },
             "cleanliness": {
               "dislike": {
                 "change_in_points": null,
                 "over_period": null
               },
               "like": {
                 "change_in_points": null,
                 "over_period": null
               },
               "neutral": {
                 "change_in_points": null,
                 "over_period": null
               }
             },
             "food_quality": {
               "dislike": {
                 "change_in_points": null,
                 "over_period": null
               },
               "like": {
                 "change_in_points": null,
                 "over_period": null
               },
               "neutral": {
                 "change_in_points": null,
                 "over_period": null
               }
             },
             "friendliness_of_service": {
               "dislike": {
                 "change_in_points": null,
                 "over_period": null
               },
               "like": {
                 "change_in_points": null,
                 "over_period": null
               },
               "neutral": {
                 "change_in_points": null,
                 "over_period": null
               }
             },
             "speed_of_service": {
               "dislike": {
                 "change_in_points": null,
                 "over_period": null
               },
               "like": {
                 "change_in_points": null,
                 "over_period": null
               },
               "neutral": {
                 "change_in_points": null,
                 "over_period": null
               }
             },
             "value_for_money": {
               "dislike": {
                 "change_in_points": null,
                 "over_period": null
               },
               "like": {
                 "change_in_points": null,
                 "over_period": null
               },
               "neutral": {
                 "change_in_points": null,
                 "over_period": null
               }
             }
           },
           "demographics": {
             "female": {
               "change_in_points": null,
               "over_period": null
             },
             "male": {
               "change_in_points": null,
               "over_period": null
             }
           },
           "feedbacks_count": {
             "average_per_day": 0.0,
             "change_in_percentage": null,
             "over_period": 0
           },
           "net_promoter_score": {
             "detractors": {
               "change_in_points": null,
               "over_period": null
             },
             "feedbacks_count": {
               "change_in_percentage": null,
               "over_period": 0
             },
             "passives": {
               "change_in_points": null,
               "over_period": null
             },
             "promoters": {
               "change_in_points": null,
               "over_period": null
             },
             "score": {
               "change_in_points": null,
               "over_period": null
             }
           },
           "redemptions_count": {
             "average_per_day": 0.0,
             "change_in_percentage": null,
             "over_period": 0
           },
           "rewards_pool": {
             "change_in_percentage": null,
             "over_period": 0
           },
           "users": {
             "new": {
               "average_per_day": 0.0,
               "change_in_percentage": null,
               "over_period": 0
             },
             "returning": {
               "average_per_day": 0.0,
               "change_in_percentage": null,
               "over_period": 0
             }
           }
         },
         "detailed_statistics": {
           "2013-08-02": {
             "food_quality": {
               "like"    : 0,
               "dislike" : 0,
               "neutral" : 0
             },
             "speed_of_service": {
               "like"    : 0,
               "dislike" : 0,
               "neutral" : 0
             },
             "friendliness_of_service": {
               "like"    : 0,
               "dislike" : 0,
               "neutral" : 0
             },
             "ambience": {
               "like"    : 0,
               "dislike" : 0,
               "neutral" : 0
             },
             "cleanliness": {
               "like"    : 0,
               "dislike" : 0,
               "neutral" : 0
             },
             "value_for_money": {
               "like"    : 0,
               "dislike" : 0,
               "neutral" : 0
             },
             "net_promoter_score": {
               "like"    : 0,
               "dislike" : 0,
               "neutral" : 0
             },
             "usage": {
               "feedbacks_count": 0,
               "redemptions_count": 0,
               "discounts_claimed": 0,
               "points_issued": 0,
               "rewards_pool": 0
             },
             "customers": {
               "male": 0,
               "female": 0,
               "new_users": 0,
               "returning_users": 0,
               "time_of_visit": {"0": 0,  "1": 0,  "2": 0,  "3": 0,  "4": 0,  "5": 0,  "6": 0,  "7": 0,  "8": 0,  "9": 0,  "10": 0, "11": 0,
                                 "12": 0, "13": 0, "14": 0, "15": 0, "16": 0, "17": 0, "18": 0, "19": 0, "20": 0, "21": 0, "22": 0, "23": 0}
             },
             "average_bill_amount": 0
           },
           "2013-08-01": {
             "food_quality": {
               "like"    : 0,
               "dislike" : 0,
               "neutral" : 0
             },
             "speed_of_service": {
               "like"    : 0,
               "dislike" : 0,
               "neutral" : 0
             },
             "friendliness_of_service": {
               "like"    : 0,
               "dislike" : 0,
               "neutral" : 0
             },
             "ambience": {
               "like"    : 0,
               "dislike" : 0,
               "neutral" : 0
             },
             "cleanliness": {
               "like"    : 0,
               "dislike" : 0,
               "neutral" : 0
             },
             "value_for_money": {
               "like"    : 0,
               "dislike" : 0,
               "neutral" : 0
             },
             "net_promoter_score": {
               "like"    : 0,
               "dislike" : 0,
               "neutral" : 0
             },
             "usage": {
               "feedbacks_count": 0,
               "redemptions_count": 0,
               "discounts_claimed": 0,
               "points_issued": 0,
               "rewards_pool": 0
             },
             "customers": {
               "male": 0,
               "female": 0,
               "new_users": 0,
               "returning_users": 0,
               "time_of_visit": {"0": 0,  "1": 0,  "2": 0,  "3": 0,  "4": 0,  "5": 0,  "6": 0,  "7": 0,  "8": 0,  "9": 0,  "10": 0, "11": 0,
                                 "12": 0, "13": 0, "14": 0, "15": 0, "16": 0, "17": 0, "18": 0, "19": 0, "20": 0, "21": 0, "22": 0, "23": 0}
             },
             "average_bill_amount": 0
           }
         }
       }
      }
      """

   Scenario: User is not authorized : Manager of one Outlet accesses insights from another outlet
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |101       |Donald     |admin@subway.com               | password123 | donald_auth_token     | customer_admin  |
         |102       |Stephen    |manager@subway.com             | password123 | stephen_auth_token    | manager         |
         |103       |Alan       |admin@taj.com                  | password123 | alan_auth_token       | customer_admin  |
         |104       |Jack       |manager@taj.com                | password123 | jack_auth_token       | manager         |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" was created on "2013-01-01 00:00:00"
        And the outlet has "1000" points in its rewards pool
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      Given a customer named "Taj" exists with id "200" with admin "admin@subway.com"
        And the customer with id "200" has an outlet named "Taj - Bangalore" with id "20" with manager "manager@taj.com"
	And outlet "Taj - Bangalore" was created on "2013-01-01 00:00:00"
        And the outlet has "1000" points in its rewards pool
        And outlet "Taj - Bangalore" has staffs
          |staff.bangalore.1@Taj.com   |
          |staff.bangalore.2@Taj.com   |
      When I authenticate as the user "stephen_auth_token" with the password "random string"
      And I send a GET request to "/api/feedbacks/trends" with the following:
      """
      outlet_id=20&start_time=2013-08-01 00:00:00&end_time=2013-08-02 23:59:59
      """
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors": ["Insufficient privileges"]}
      """

     Scenario: User is not authorized : User's role is "staff" OR "user"
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
	And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
	And outlet "Subway - Bangalore" was created on "2013-01-01 00:00:00"
        And the outlet has "1000" points in its rewards pool
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
        And his role is "<role>"
        And his authentication token is "auth_token_123"
        And he has "100" points
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/feedbacks/trends" with the following:
      """
      outlet_id=10&start_time=2013-08-01 00:00:00&end_time=2013-08-02 23:59:59
      """
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors": ["Insufficient privileges"]}
      """

   Scenario: User is not authenticated
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_1234" with the password "random string"
       And I send a GET request to "/api/feedbacks/trends" with the following:
       """
       start_time=2013-07-07 00:00:00&end_time=2013-07-07 11:59:59 PM
       """
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors" : ["Invalid login credentials"]}
      """
