Feature: List Kanari Codes for pending feedbacks

    Background:
      Given I send and accept JSON

    Scenario: Staff successfully lists kanari codes, that are not completed i.e. feedback is not given
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |101       |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
	    And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" was created before "10" days
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the following feedbacks exist
          |id  |outlet_id |user_id |points |bill_amount |code   | completed | updated_at            |food_quality |speed_of_service |friendliness_of_service |ambience |cleanliness |value_for_money |recommendation_rating |
          |1   |10        |1000    |400    |4000        |12345  | nil       | "2013-07-08 00:00:00" |nil          |nil              |nil                     |nil      |nil         |nil             | nil                  |
		  |2   |10        |3000    |100    |1000        |nil    | true      | "2013-07-07 01:00:00" |1            |-1               |0                       |-1       |-1          |4               | 9                    |
		  |3   |10        |4000    |200    |2000        |34567  | nil       | "2013-07-06 02:00:00" |nil          |nil              |nil                     |nil      |nil         |nil             | nil                  |
		  |4   |20        |1000    |200    |2000        |45678  | nil       | "2013-07-05 02:00:00" |nil          |nil              |nil                     |nil      |nil         |nil             | nil                  |
		  |5   |30        |2000    |200    |2000        |56789  | nil       | "2013-07-04 02:00:00" |nil          |nil              |nil                     |nil      |nil         |nil             | nil                  |
      When I authenticate as the user "donald_auth_token" with the password "random string"
      And I send a GET request to "/api/feedbacks" with the following:
      """
      type=pending
      """
	  Then the response status should be "200"
	  And the JSON response should be:
      """
      {
        "feedbacks": [
          {
            "id": 1,
            "food_quality": 0,
            "speed_of_service": 0,
            "friendliness_of_service": 0,
            "ambience": 0,
            "cleanliness": 0,
            "value_for_money": 0,
            "comment": null,
            "points": 400,
            "bill_amount": 4000,
            "code": "12345",
            "updated_at": "2013-07-08 00:00:00",
            "promoter_score": 0
          },
          {
            "id": 3,
            "food_quality": 0,
            "speed_of_service": 0,
            "friendliness_of_service": 0,
            "ambience": 0,
            "cleanliness": 0,
            "value_for_money": 0,
            "comment": null,
            "points": 200,
            "bill_amount": 2000,
            "code": "34567",
            "updated_at": "2013-07-06 00:00:00",
            "promoter_score": 0
          }
        ]
      }
	  """

   Scenario: Staff successfully lists pending feedbacks from a given time
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |101       |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
	    And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" was created before "10" days
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the following feedbacks exist
          |id  |outlet_id |user_id |points |bill_amount |code   | completed | updated_at            |food_quality |speed_of_service |friendliness_of_service |ambience |cleanliness |value_for_money |recommendation_rating |
		  |1   |10        |1000    |400    |4000        |12345  | nil       | "2013-07-08 00:00:00" |nil          |nil              |nil                     |nil      |nil         |nil             | nil                  |
		  |2   |10        |3000    |100    |1000        |nil    | true      | "2013-07-07 01:00:00" |1            |-1               |0                       |-1       |-1          |4               | 9                    |
		  |3   |10        |4000    |200    |2000        |34567  | nil       | "2013-07-06 02:00:00" |nil          |nil              |nil                     |nil      |nil         |nil             | nil                  |
		  |4   |20        |1000    |200    |2000        |45678  | nil       | "2013-07-05 02:00:00" |nil          |nil              |nil                     |nil      |nil         |nil             | nil                  |
		  |5   |30        |2000    |200    |2000        |56789  | nil       | "2013-07-04 02:00:00" |nil          |nil              |nil                     |nil      |nil         |nil             | nil                  |
      When I authenticate as the user "donald_auth_token" with the password "random string"
      And I send a GET request to "/api/feedbacks" with the following:
      """
      type=pending&start_time="2013-07-07 11:11:11"
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "feedbacks": [
          {
            "id": 1,
            "food_quality": 0,
            "speed_of_service": 0,
            "friendliness_of_service": 0,
            "ambience": 0,
            "cleanliness": 0,
            "value_for_money": 0,
            "comment": null,
            "points": 400,
            "bill_amount": 4000,
            "code": "12345",
            "updated_at": "2013-07-08 00:00:00",
            "promoter_score": 0
          }
        ]
      }
      """

   Scenario: Staff successfully lists pending feedbacks within a start and end time
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |101       |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
	    And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" was created before "10" days
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the following feedbacks exist
          |id  |outlet_id |user_id |points |bill_amount |code   | completed | updated_at            |food_quality |speed_of_service |friendliness_of_service |ambience |cleanliness |value_for_money |recommendation_rating |
		  |1   |10        |1000    |400    |4000        |12345  | nil       | "2013-07-08 00:00:00" |nil          |nil              |nil                     |nil      |nil         |nil             | nil                  |
		  |2   |10        |3000    |100    |1000        |nil    | true      | "2013-07-07 01:00:00" |1            |-1               |0                       |-1       |-1          |4               | 9                    |
		  |3   |10        |4000    |200    |2000        |34567  | nil       | "2013-07-06 02:00:00" |nil          |nil              |nil                     |nil      |nil         |nil             | nil                  |
		  |4   |20        |1000    |200    |2000        |45678  | nil       | "2013-07-05 02:00:00" |nil          |nil              |nil                     |nil      |nil         |nil             | nil                  |
		  |5   |30        |2000    |200    |2000        |56789  | nil       | "2013-07-04 02:00:00" |nil          |nil              |nil                     |nil      |nil         |nil             | nil                  |
      When I authenticate as the user "donald_auth_token" with the password "random string"
      And I send a GET request to "/api/feedbacks" with the following:
      """
      type=pending&start_time=2013-07-06 00:00:00&end_time=2013-07-07 11:59:59
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "feedbacks": [
          {
            "id": 3,
            "food_quality": 0,
            "speed_of_service": 0,
            "friendliness_of_service": 0,
            "ambience": 0,
            "cleanliness": 0,
            "value_for_money": 0,
            "comment": null,
            "points": 200,
            "bill_amount": 2000,
            "code": "34567",
            "updated_at": "2013-07-06 00:00:00",
            "promoter_score": 0
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
        And outlet "Subway - Bangalore" was created before "10" days
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the following feedbacks exist
          |id  |outlet_id |user_id |points |bill_amount |code   | completed | updated_at            |food_quality |speed_of_service |friendliness_of_service |ambience |cleanliness |value_for_money |recommendation_rating |
          |1   |10        |1000    |400    |4000        |12345  | nil       | "2013-07-08 00:00:00" |nil          |nil              |nil                     |nil      |nil         |nil             | nil                  |
          |2   |10        |3000    |100    |1000        |nil    | true      | "2013-07-07 01:00:00" |1            |-1               |0                       |-1       |-1          |4               | 9                    |
          |3   |10        |4000    |200    |2000        |34567  | nil       | "2013-07-06 02:00:00" |nil          |nil              |nil                     |nil      |nil         |nil             | nil                  |
          |4   |20        |1000    |200    |2000        |45678  | nil       | "2013-07-05 02:00:00" |nil          |nil              |nil                     |nil      |nil         |nil             | nil                  |
          |5   |30        |2000    |200    |2000        |56789  | nil       | "2013-07-04 02:00:00" |nil          |nil              |nil                     |nil      |nil         |nil             | nil                  |
      When I authenticate as the user "mike_auth_token" with the password "random string"
      And I send a GET request to "/api/feedbacks" with the following:
      """
      type=pending&outlet_id=10&start_time=2013-07-07 00:00:00&end_time=2013-07-07 11:59:59 PM
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
