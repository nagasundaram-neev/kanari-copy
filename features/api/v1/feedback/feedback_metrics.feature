Feature: Metrics for Feedback

    Background:
      Given I send and accept JSON

	Scenario: Staff or Manager successfully fetch feedback metrics for today
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |101       |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
	    And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
		And outlet "Subway - Bangalore" was created on "2013-01-01 00:00:00"
        And the outlet has "1000" points in its rewards pool
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the following feedbacks exist for yesterday
          |id  |outlet_id |user_id |points |food_quality |speed_of_service |friendliness_of_service |ambience |cleanliness |value_for_money |recommendation_rating | comment                                                             | completed  |
		  |1   |10        |1000    |400    |1            |1                |1                       |1        |1           |1               |10                     | I really enjoyed the pizza's in the out area by the street          | true       |
		  |2   |10        |1001    |100    |1            |1                |1                       |1        |1           |1               |9                     | I am dissapointed with the service                                  | true       |
		  |3   |10        |1002    |400    |1            |1                |1                       |1        |0           |1               |9                     | I really enjoyed the pizza's in the out area by the street          | true       |
		  |4   |10        |1003    |100    |0            |1                |1                       |0        |0           |1               |8                     | I am dissapointed with the service                                  | true       |
		  |5   |10        |1004    |400    |0            |0                |1                       |0        |0           |1               |7                     | I really enjoyed the pizza's in the out area by the street          | true       |
		  |6   |10        |3000    |100    |-1           |0                |0                       |0        |-1          |1               |6                     | I am dissapointed with the service                                  | true       |
		  |7   |10        |1000    |400    |-1           |-1               |-1                      |0        |-1          |0               |5                     | I really enjoyed the pizza's in the out area by the street          | true       |
		  |8   |10        |3000    |100    |-1           |-1               |-1                      |0        |-1          |0               |4                     | I am dissapointed with the service                                  | true       |
		  |9   |10        |1000    |400    |-1           |-1               |-1                      |0        |-1          |-1              |4                     | I really enjoyed the pizza's in the out area by the street          | true       |
		  |10  |10        |3000    |100    |-1           |-1                |-1                     |-1       |-1          |-1              |3                     | I am dissapointed with the service                                  | true       |
		  |11  |20        |4000    |200    |nil          |nil              |nil                     |nil      |nil         |nil             |nil                    | nil                                                                | nil        |
		  |12  |20        |1000    |100    |nil          |nil              |nil                     |nil      |nil         |nil             |nil                    | nil                                                                | nil        |
		  |13  |30        |2000    |200    |1            |0                |1                       |1        |1           |1               |10                    | Yummy chickens, I really liked it.                                  | true       |
        And the following feedbacks exist for today
          |id  |outlet_id |user_id |points |food_quality |speed_of_service |friendliness_of_service |ambience |cleanliness |value_for_money |recommendation_rating | comment                                                   | completed  |
		  |21   |10        |1000    |400    |1                |1           |1                      |1        |1      |1               |10                     | I really enjoyed the pizza's in the out area by the street     | true       |
		  |22   |10        |1001    |100    |1                |1            |1                      |1        |1      |1               |9                     | I am dissapointed with the service                             | true       |
		  |23   |10        |1002    |400    |1                |1            |1                      |1        |0      |1               |9                     | I really enjoyed the pizza's in the out area by the street     | true       |
		  |24   |10        |1003    |100    |1                |1            |0                      |0        |0      |1               |8                     | I am dissapointed with the service                             | true       |
		  |25   |10        |1004    |400    |0                |1            |0                      |0        |0      |1               |7                     | I really enjoyed the pizza's in the out area by the street     | true       |
		  |26   |10        |3000    |100    |0                |0            |-1                     |0        |-1     |1               |6                     | I am dissapointed with the service                             | true       |
		  |27   |10        |1000    |400    |-1               |-1           |-1                     |0        |-1     |0               |5                     | I really enjoyed the pizza's in the out area by the street     | true       |
		  |28   |10        |3000    |100    |-1               |-1           |-1                     |0        |-1     |0               |4                     | I am dissapointed with the service                             | true       |
		  |29   |10        |1000    |400    |-1               |-1           |-1                     |0        |-1     |-1              |4                     | I really enjoyed the pizza's in the out area by the street     | true       |
		  |30  |10        |3000    |100     |-1               |-1           |-1                     |-1       |-1     |-1              |3                     | I am dissapointed with the service                             | true       |
		  |31  |20        |4000    |200     |nil              |nil          |nil                    |nil      |nil    |nil             |nil                    | nil                                                           | nil        |
		  |32  |20        |1000    |100     |nil              |nil          |nil                    |nil      |nil    |nil             |nil                    | nil                                                           | nil        |
		  |33  |30        |2000    |200     |0                |1            |1                      |1        |1      |1               |10                    | Yummy chickens, I really liked it.                             | true       |
      When I authenticate as the user "donald_auth_token" with the password "random string"
      And I send a GET request to "/api/feedbacks/metrics"
	  Then the response status should be "200"
      And the JSON response should be:
      """
      {
	    "feedback_insights": {
         "food_quality": {
           "like"    : 40,
           "dislike" : 40,
           "neutral" : 20,
           "change"  : 20 
         },
         "speed_of_service": {
           "like"    : 50,
           "dislike" : 40,
           "neutral" : 10,
           "change"  : 10
         },
         "friendliness_of_service": {
           "like"    : 30,
           "dislike" : 50,
           "neutral" : 20,
           "change"  : -30 
         },
         "ambience": {
           "like"    : 30,
           "dislike" : 10,
           "neutral" : 60,
           "change"  : 0
         },
         "cleanliness": {
           "like"    : 20,
           "dislike" : 50,
           "neutral" : 30,
           "change"  : 0
         },
         "value_for_money": {
           "like"    : 60,
           "dislike" : 20,
           "neutral" : 20,
           "change"  : 0
         },
         "net_promoter_score": {
           "like"    : 30,
           "dislike" : 50,
           "neutral" : 20,
           "change"  : 0 
         },
         "feedbacks_count": 10,
         "rewards_pool": 1000
        }
      }
	  """

	Scenario: Manager successfully fetch feedback metrics for any day
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |100       |Tom        |manager@subway.com             | password123 | tom_auth_token        | manager         |
         |101       |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
	    And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
		And outlet "Subway - Bangalore" was created on "2013-01-01 00:00:00"
        And the outlet has "1000" points in its rewards pool
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the following feedbacks exist for "2013-05-05"
          |id  |outlet_id |user_id |points |food_quality |speed_of_service |friendliness_of_service |ambience |cleanliness |value_for_money |recommendation_rating | comment                                                             | completed  |
		  |1   |10        |1000    |400    |1            |1                |1                       |1        |1           |1               |10                     | I really enjoyed the pizza's in the out area by the street          | true       |
		  |2   |10        |1001    |100    |1            |1                |1                       |1        |1           |1               |9                     | I am dissapointed with the service                                  | true       |
		  |3   |10        |1002    |400    |1            |1                |1                       |1        |0           |1               |9                     | I really enjoyed the pizza's in the out area by the street          | true       |
		  |4   |10        |1003    |100    |0            |1                |1                       |0        |0           |1               |8                     | I am dissapointed with the service                                  | true       |
		  |5   |10        |1004    |400    |0            |0                |1                       |0        |0           |1               |7                     | I really enjoyed the pizza's in the out area by the street          | true       |
		  |6   |10        |3000    |100    |-1           |0                |0                       |0        |-1          |1               |6                     | I am dissapointed with the service                                  | true       |
		  |7   |10        |1000    |400    |-1           |-1               |-1                      |0        |-1          |0               |9                     | I really enjoyed the pizza's in the out area by the street          | true       |
		  |8   |10        |3000    |100    |-1           |-1               |-1                      |0        |-1          |0               |9                     | I am dissapointed with the service                                  | true       |
		  |9   |10        |1000    |400    |-1           |-1               |-1                      |0        |-1          |-1              |4                     | I really enjoyed the pizza's in the out area by the street          | true       |
		  |10  |10        |3000    |100    |-1           |-1                |-1                     |-1       |-1          |-1              |3                     | I am dissapointed with the service                                  | true       |
		  |11  |20        |4000    |200    |nil          |nil              |nil                     |nil      |nil         |nil             |nil                    | nil                                                                | nil        |
		  |12  |20        |1000    |100    |nil          |nil              |nil                     |nil      |nil         |nil             |nil                    | nil                                                                | nil        |
		  |13  |30        |2000    |200    |1            |0                |1                       |1        |1           |1               |10                    | Yummy chickens, I really liked it.                                  | true       |
        And the following feedbacks exist for "2013-05-06"
          |id  |outlet_id |user_id |points |food_quality |speed_of_service |friendliness_of_service |ambience |cleanliness |value_for_money |recommendation_rating | comment                                                   | completed  |
		  |21   |10        |1000    |400    |1                |1           |1                      |1        |1      |1               |10                     | I really enjoyed the pizza's in the out area by the street     | true       |
		  |22   |10        |1001    |100    |1                |1            |1                      |1        |1      |1               |9                     | I am dissapointed with the service                             | true       |
		  |23   |10        |1002    |400    |1                |1            |1                      |1        |0      |1               |9                     | I really enjoyed the pizza's in the out area by the street     | true       |
		  |24   |10        |1003    |100    |1                |1            |0                      |0        |0      |1               |9                     | I am dissapointed with the service                             | true       |
		  |25   |10        |1004    |400    |0                |1            |0                      |0        |0      |1               |9                     | I really enjoyed the pizza's in the out area by the street     | true       |
		  |26   |10        |3000    |100    |0                |0            |-1                     |0        |-1     |1               |6                     | I am dissapointed with the service                             | true       |
		  |27   |10        |1000    |400    |-1               |-1           |-1                     |0        |-1     |0               |5                     | I really enjoyed the pizza's in the out area by the street     | true       |
		  |28   |10        |3000    |100    |-1               |-1           |-1                     |0        |-1     |0               |9                     | I am dissapointed with the service                             | true       |
		  |29   |10        |1000    |400    |-1               |-1           |-1                     |0        |-1     |-1              |9                     | I really enjoyed the pizza's in the out area by the street     | true       |
		  |30  |10        |3000    |100     |-1               |-1           |-1                     |-1       |-1     |-1              |8                     | I am dissapointed with the service                             | true       |
		  |31  |20        |4000    |200     |nil              |nil          |nil                    |nil      |nil    |nil             |nil                    | nil                                                           | nil        |
		  |32  |20        |1000    |100     |nil              |nil          |nil                    |nil      |nil    |nil             |nil                    | nil                                                           | nil        |
		  |33  |30        |2000    |200     |0                |1            |1                      |1        |1      |1               |10                    | Yummy chickens, I really liked it.                             | true       |
      When I authenticate as the user "tom_auth_token" with the password "random string"
	  And I send a GET request to "/api/feedbacks/metrics" with the following:
	  """
	  date=2013-05-06
	  """
	  Then the response status should be "200"
      And the JSON response should be:
      """
      {
	    "feedback_insights": {
         "food_quality": {
           "like"    : 40,
           "dislike" : 40,
           "neutral" : 20,
           "change"  : 20 
         },
         "speed_of_service": {
           "like"    : 50,
           "dislike" : 40,
           "neutral" : 10,
           "change"  : 10
         },
         "friendliness_of_service": {
           "like"    : 30,
           "dislike" : 50,
           "neutral" : 20,
           "change"  : -30 
         },
         "ambience": {
           "like"    : 30,
           "dislike" : 10,
           "neutral" : 60,
           "change"  : 0
         },
         "cleanliness": {
           "like"    : 20,
           "dislike" : 50,
           "neutral" : 30,
           "change"  : 0
         },
         "value_for_money": {
           "like"    : 60,
           "dislike" : 20,
           "neutral" : 20,
           "change"  : 0
         },
         "net_promoter_score": {
           "like"    : 60,
           "dislike" : 25,
           "neutral" : 15,
           "change"  : 15
         },
         "feedbacks_count": 10,
         "rewards_pool": 1000
        }
      }
	  """

	Scenario: Outlet doesn't have any feedbacks
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |101       |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
	    And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
		And outlet "Subway - Bangalore" was created on "2013-01-01 00:00:00"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the outlet doesn't have any feedback
      When I authenticate as the user "donald_auth_token" with the password "random string"
      And I send a GET request to "/api/feedbacks/metrics"
	  Then the response status should be "200"
      And the JSON response should be:
      """
      {
	    "feedback_insights": {
         "food_quality": {
           "like"    : 0,
           "dislike" : 0,
           "neutral" : 0,
           "change"  : 0 
         },
         "speed_of_service": {
           "like"    : 0,
           "dislike" : 0,
           "neutral" : 0,
           "change"  : 0
         },
         "friendliness_of_service": {
           "like"    : 0,
           "dislike" : 0,
           "neutral" : 0,
           "change"  : 0 
         },
         "ambience": {
           "like"    : 0,
           "dislike" : 0,
           "neutral" : 0,
           "change"  : 0
         },
         "cleanliness": {
           "like"    : 0,
           "dislike" : 0,
           "neutral" : 0,
           "change"  : 0
         },
         "value_for_money": {
           "like"    : 0,
           "dislike" : 0,
           "neutral" : 0,
           "change"  : 0
         },
         "net_promoter_score": {
           "like"    : 0,
           "dislike" : 0,
           "neutral" : 0,
           "change"  : 0 
         },
         "feedbacks_count": 0,
         "rewards_pool": 0
        }
      }
	  """


	Scenario: User is not authorized : Staff of one Outlet accesses insights from another outlet
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |101       |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
         |102       |Stephen    |staff.bangalore.1@Taj.com      | password123 | stephen_auth_token    | staff           |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
	    And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
		And outlet "Subway - Bangalore" was created on "2013-01-01 00:00:00"
        And the outlet has "1000" points in its rewards pool
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      Given a customer named "Taj" exists with id "200" with admin "admin@subway.com"
	    And the customer with id "200" has an outlet named "Taj - Bangalore" with id "20" with manager "manager@subway.com"
		And outlet "Taj - Bangalore" was created on "2013-01-01 00:00:00"
        And the outlet has "1000" points in its rewards pool
        And outlet "Taj - Bangalore" has staffs
          |staff.bangalore.1@Taj.com   |
          |staff.bangalore.2@Taj.com   |
      When I authenticate as the user "stephen_auth_token" with the password "random string"
	  And I send a GET request to "/api/feedbacks/metrics" with the following:
      """
      outlet_id=10
      """
	  Then the response status should be "403"
	  And the JSON response should be:
	  """
      {"errors": ["Insufficient privileges"]}
	  """

	Scenario: User is not authorized : User's role is "user"
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |101       |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
         |102       |Stephen    |staff.bangalore.1@Taj.com      | password123 | stephen_auth_token    | staff           |
         |103       |Alice      |normaluser@gmail.com           | password123 | alice_auth_token      | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
	    And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
		And outlet "Subway - Bangalore" was created on "2013-01-01 00:00:00"
        And the outlet has "1000" points in its rewards pool
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      When I authenticate as the user "alice_auth_token" with the password "random string"
	  And I send a GET request to "/api/feedbacks/metrics" with the following:
      """
      outlet_id=10
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
	  And I send a GET request to "/api/feedbacks" with the following:
	  """
	  start_time=2013-07-07 00:00:00&end_time=2013-07-07 11:59:59 PM
	  """
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors" : ["Invalid login credentials"]}
      """
