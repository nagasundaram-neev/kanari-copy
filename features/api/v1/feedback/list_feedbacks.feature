Feature: Lists Feedback

    Background:
      Given I send and accept JSON

	Scenario: Staff successfully lists completed feedbacks
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |101       |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
	    And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
		And outlet "Subway - Bangalore" was created on "2013-01-01 00:00:00"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the following feedbacks exist
          |id  |outlet_id |user_id |points |bill_amount |food_quality |speed_of_service |friendliness_of_service |ambience |cleanliness |value_for_money |recommendation_rating | comment                                                               | completed  | updated_at  | user_status |
		  |1   |10        |1000    |400    |4000.99     |1            |-1               |0                       |1        |1           |1               |9                     | I really enjoyed the pizza's in the out area by the street          | true       | "2013-07-08 00:00:00" |reach_out|
		  |2   |10        |3000    |100    |1000.99     |1            |1                |-1                      |0        |-1          |-1              |4                     | I am dissapointed with the service                                  | true       | "2013-07-07 01:00:00" |reach_out|
		  |3   |10        |4000    |200    |2000.99     |nil          |nil              |nil                     |nil      |nil         |nil             |nil                    | nil                                                                | nil        | "2013-07-06 02:00:00" |reach_out|
		  |4   |20        |1000    |100    |1000.99     |nil          |nil              |nil                     |nil      |nil         |nil             |nil                    | nil                                                                | nil        | "2013-07-06 02:00:00" |reach_out|
		  |5   |30        |2000    |200    |2000.99     |1            |0                |1                       |1        |1           |1               |10                    | Yummy chickens, I really liked it.                                  | true       | "2013-07-06 00:06:00" |reach_out|
      When I authenticate as the user "donald_auth_token" with the password "random string"
      And I send a GET request to "/api/feedbacks"
	  Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "feedbacks": [
          {
            "id": 1,
            "food_quality": 1,
            "speed_of_service": -1,
            "friendliness_of_service": 0,
            "ambience": 1,
            "cleanliness": 1,
            "value_for_money": 1,
            "comment": "I really enjoyed the pizza's in the out area by the street",
            "points": 400,
            "bill_amount": 4000.99,
            "code": null,
            "updated_at": "2013-07-08 00:00:00",
            "promoter_score": 9,
            "user_status": "reach_out"
		  },
          {
            "id": 2,
            "food_quality": 1,
            "speed_of_service": 1,
            "friendliness_of_service": -1,
            "ambience": 0,
            "cleanliness": -1,
            "value_for_money": -1,
            "comment": "I am dissapointed with the service",
            "points": 100,
            "bill_amount": 1000.99,
            "code": null,
            "updated_at": "2013-07-07 01:00:00",
            "promoter_score": 4,
            "user_status": "reach_out"
          }
        ]
      }
	  """

	Scenario: Staff successfully lists completed feedbacks from a given time
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |101       |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
	    And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
		And outlet "Subway - Bangalore" was created on "2013-01-01 00:00:00"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the following feedbacks exist
          |id  |outlet_id |user_id |points |bill_amount |food_quality |speed_of_service |friendliness_of_service |ambience |cleanliness |value_for_money |recommendation_rating | comment                                                               | completed  | updated_at  | user_status |
		  |1   |10        |1000    |400    |4000        |1            |-1               |0                       |1        |1           |1               |9                     | I really enjoyed the pizza's in the out area by the street          | true       | "2013-07-08 00:00:00" |reach_out|
		  |2   |10        |3000    |100    |1000        |1            |1                |-1                      |0        |-1          |-1              |4                     | I am dissapointed with the service                                  | true       | "2013-07-07 01:00:00" |reach_out|
		  |3   |10        |4000    |200    |2000        |nil          |nil              |nil                     |nil      |nil         |nil             |nil                    | nil                                                                | nil        | "2013-07-06 02:00:00" |reach_out|
		  |4   |20        |1000    |100    |1000        |nil          |nil              |nil                     |nil      |nil         |nil             |nil                    | nil                                                                | nil        | "2013-07-06 02:00:00" |reach_out|
		  |5   |30        |2000    |200    |2000        |1            |0                |1                       |1        |1           |1               |10                    | Yummy chickens, I really liked it.                                  | true       | "2013-07-06 00:06:00" |reach_out|
      When I authenticate as the user "donald_auth_token" with the password "random string"
	  And I send a GET request to "/api/feedbacks" with the following:
	  """
	  start_time="2013-07-07 11:11:11"
	  """
	  Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "feedbacks": [
          {
            "id": 1,
            "food_quality": 1,
            "speed_of_service": -1,
            "friendliness_of_service": 0,
            "ambience": 1,
            "cleanliness": 1,
            "value_for_money": 1,
            "comment": "I really enjoyed the pizza's in the out area by the street",
            "points": 400,
            "bill_amount": 4000.0,
            "code": null,
            "updated_at": "2013-07-08 00:00:00",
            "promoter_score": 9,
            "user_status": "reach_out"
		  }
        ]
      }
	  """

	Scenario: Staff successfully lists completed feedbacks within a start and end time
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |101       |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
	    And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
		And outlet "Subway - Bangalore" was created on "2013-01-01 00:00:00"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the following feedbacks exist
          |id  |outlet_id |user_id |points |bill_amount |food_quality |speed_of_service |friendliness_of_service |ambience |cleanliness |value_for_money |recommendation_rating | comment                                                               | completed  | updated_at  | user_status |
		  |1   |10        |1000    |400    |4000.99    |1            |-1               |0                       |1        |1           |1               |9                     | I really enjoyed the pizza's in the out area by the street          | true       | "2013-07-08 00:00:00" |reach_out|
		  |2   |10        |3000    |100    |1000.99    |1            |1                |-1                      |0        |-1          |-1              |4                     | I am dissapointed with the service                                  | true       | "2013-07-07 01:00:00" |reach_out|
		  |3   |10        |4000    |200    |2000.99    |nil          |nil              |nil                     |nil      |nil         |nil             |nil                    | nil                                                                | nil        | "2013-07-06 02:00:00" |reach_out|
		  |4   |20        |1000    |100    |1000.99    |nil          |nil              |nil                     |nil      |nil         |nil             |nil                    | nil                                                                | nil        | "2013-07-06 02:00:00" |reach_out|
		  |5   |30        |2000    |200    |2000.99    |1            |0                |1                       |1        |1           |1               |10                    | Yummy chickens, I really liked it.                                  | true       | "2013-07-06 00:06:00" |reach_out|
      When I authenticate as the user "donald_auth_token" with the password "random string"
	  And I send a GET request to "/api/feedbacks" with the following:
	  """
	  start_time=2013-07-07 00:00:00&end_time=2013-07-07 11:59:59 PM
	  """
	  Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "feedbacks": [
          {
            "id": 2,
            "food_quality": 1,
            "speed_of_service": 1,
            "friendliness_of_service": -1,
            "ambience": 0,
            "cleanliness": -1,
            "value_for_money": -1,
            "comment": "I am dissapointed with the service",
            "points": 100,
            "bill_amount": 1000.99,
            "code": null,
            "updated_at": "2013-07-07 01:00:00",
            "promoter_score": 4,
            "user_status": "reach_out"
		  }
        ]
      }
      """

    Scenario: User is not authorized, User's role is 'user'
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |3000      |Mike       |simpleuser@gmail.com           | password123 | mike_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
	    And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
		And outlet "Subway - Bangalore" was created on "2013-01-01 00:00:00"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the following feedbacks exist
          |id  |outlet_id |user_id |points |bill_amount |food_quality |speed_of_service |friendliness_of_service |ambience |cleanliness |value_for_money |recommendation_rating | comment                                                               | completed  | updated_at  | user_status |
		  |1   |10        |1000    |400    |4000        |1            |-1               |0                       |1        |1           |1               |9                     | I really enjoyed the pizza's in the out area by the street          | true       | "2013-07-08 00:00:00" |reach_out|
		  |2   |10        |3000    |100    |1000        |1            |1                |-1                      |0        |-1          |-1              |4                     | I am dissapointed with the service                                  | true       | "2013-07-07 01:00:00" |reach_out|
		  |3   |10        |4000    |200    |2000        |nil          |nil              |nil                     |nil      |nil         |nil             |nil                    | nil                                                                | nil        | "2013-07-06 02:00:00" |reach_out|
		  |4   |20        |1000    |100    |1000        |nil          |nil              |nil                     |nil      |nil         |nil             |nil                    | nil                                                                | nil        | "2013-07-06 02:00:00" |reach_out|
		  |5   |30        |2000    |200    |2000        |1            |0                |1                       |1        |1           |1               |10                    | Yummy chickens, I really liked it.                                  | true       | "2013-07-06 00:06:00" |reach_out|
      When I authenticate as the user "mike_auth_token" with the password "random string"
	  And I send a GET request to "/api/feedbacks" with the following:
	  """
	  outlet_id=10&start_time=2013-07-07 00:00:00&end_time=2013-07-07 11:59:59 PM
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
