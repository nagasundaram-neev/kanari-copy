Feature: Lists Activities for a User 

    Background:
      Given I send and accept JSON

    Scenario: Successfully lists activities for the logged in user
      Given the following users exist
         |id        |first_name |last_name  |email                          | password    | authentication_token  | role            |
         |1         |Donald     |Knuth      |user@gmail.com                 | password123 | donald_auth_token     | user            |
         |2         |Robert     |Scobble    |anotheruser@gmail.com          | password123 | robert_auth_token     | user            |
        And the following transactions exist in "Feedback Log" table
          |id  |outlet_id |customer_id |outlet_name            |points    |user_id   |user_first_name |user_last_name | updated_at            |
          |1   |10        |100         |Subway - Bangalore     |100       |1         |Donald          |Knuth          | "2013-01-01 00:00:00" |
          |2   |20        |100         |Subway - Bhubaneswar   |200       |1         |Donald          |Knuth          | "2013-02-01 00:00:00" |
          |3   |30        |100         |Subway - Pune          |300       |2         |Robert          |Scobble        | "2013-03-01 00:00:00" |
          |4   |40        |200         |ITC - Bangalore        |400       |1         |Donald          |Knuth          | "2013-04-01 00:00:00" |
          |5   |20        |100         |Subway - Bhubaneswar   |100       |1         |Donald          |Knuth          | "2013-05-01 00:00:00" |
        And the following transactions exist in "Redemption Log" table
          |id  |outlet_id |customer_id |outlet_name            |points    |user_id   |user_first_name |user_last_name | updated_at            |
          |1   |10        |100         |Subway - Bangalore     |100       |1         |Donald          |Knuth          | "2013-02-02 00:00:00" |
          |2   |20        |100         |Subway - Bhubaneswar   |200       |1         |Donald          |Knuth          | "2013-03-03 00:00:00" |
          |3   |30        |100         |Subway - Pune          |300       |2         |Robert          |Scobble        | "2013-04-04 00:00:00" |
          |4   |40        |200         |ITC - Bangalore        |400       |1         |Donald          |Knuth          | "2013-05-05 00:00:00" |
      When I authenticate as the user "donald_auth_token" with the password "random string"
      And I send a GET request to "/api/activities"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "activities": [
          {
            "points": 400,
            "outlet_id": 40,
            "outlet_name": "ITC - Bangalore",
            "type": "Redemption",
            "updated_at": "2013-05-05 00:00:00"
          },
          {
            "points": 100,
            "outlet_id": 20,
            "outlet_name": "Subway - Bhubaneswar",
            "type": "Feedback",
            "updated_at": "2013-05-01 00:00:00"
          },
          {
            "points": 400,
            "outlet_id": 40,
            "outlet_name": "ITC - Bangalore",
            "type": "Feedback",
            "updated_at": "2013-04-01 00:00:00"
          },
          {
            "points": 200,
            "outlet_id": 20,
            "outlet_name": "Subway - Bhubaneswar",
            "type": "Redemption",
            "updated_at": "2013-03-03 00:00:00"
          },
          {
            "points": 100,
            "outlet_id": 10,
            "outlet_name": "Subway - Bangalore",
            "type": "Redemption",
            "updated_at": "2013-02-02 00:00:00"
          },
          {
            "points": 200,
            "outlet_id": 20,
            "outlet_name": "Subway - Bhubaneswar",
            "type": "Feedback",
            "updated_at": "2013-02-01 00:00:00"
          },
          {
            "points": 100,
            "outlet_id": 10,
            "outlet_name": "Subway - Bangalore",
            "type": "Feedback",
            "updated_at": "2013-01-01 00:00:00"
          }
        ]
      }
     """

   Scenario Outline: User's role is not 'user'
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
        And his role is "<role>"
        And his authentication token is "auth_token_123"
        And he has "100" points
        And the following transactions exist in "Feedback Log" table
          |id  |outlet_id |customer_id |outlet_name            |points    |user_id   |user_first_name |user_last_name | updated_at            |
          |1   |10        |100         |Subway - Bangalore     |100       |1         |Donald          |Knuth          | "2013-01-01 00:00:00" |
          |2   |20        |100         |Subway - Bhubaneswar   |200       |1         |Donald          |Knuth          | "2013-02-01 00:00:00" |
          |3   |30        |100         |Subway - Pune          |300       |2         |Robert          |Scobble        | "2013-03-01 00:00:00" |
          |4   |40        |200         |ITC - Bangalore        |400       |1         |Donald          |Knuth          | "2013-04-01 00:00:00" |
          |5   |20        |100         |Subway - Bhubaneswar   |100       |1         |Donald          |Knuth          | "2013-05-01 00:00:00" |
        And the following transactions exist in "Redemption Log" table
          |id  |outlet_id |customer_id |outlet_name            |points    |user_id   |user_first_name |user_last_name | updated_at            |
          |1   |10        |100         |Subway - Bangalore     |100       |1         |Donald          |Knuth          | "2013-02-02 00:00:00" |
          |2   |20        |100         |Subway - Bhubaneswar   |200       |1         |Donald          |Knuth          | "2013-03-03 00:00:00" |
          |3   |30        |100         |Subway - Pune          |300       |2         |Robert          |Scobble        | "2013-04-04 00:00:00" |
          |4   |40        |200         |ITC - Bangalore        |400       |1         |Donald          |Knuth          | "2013-05-05 00:00:00" |
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/activities"
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors" : ["Insufficient privileges"]}
      """
      Examples:
      |role|
      |kanari_admin|
      |customer_admin|
      |manager|
      |staff|

   Scenario: User is not authenticated
      When I authenticate as the user "invalid_auth_token" with the password "random string"
      And I send a GET request to "/api/activities"
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors" : ["Invalid login credentials"]}
      """
