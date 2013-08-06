Feature: Feedback Audit Log

    Background:
      Given I send and accept JSON

    Scenario: Successful submission of feedback by logged in user should have a Log entry
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "20"
        And the outlet has "1000" points in its rewards pool
      Given A feedback exists with the following attributes:
        |id       |10     |
        |code     |12345  |
        |points   |120    |
        |outlet_id|20      |
        |completed|false      |
        And the time limit for giving feedback is "120" minutes
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123" and user id "130"
        And his role is "user"
        And his authentication token is "auth_token_123"
        And he has "100" points
      When I authenticate as the user "auth_token_123" with the password "random string"
      When I send a PUT request to "/api/feedbacks/10" with the following:
      """
      {
        "feedback" : {
          "food_quality": -1,
          "speed_of_service": 1,
          "friendliness_of_service": 0,
          "ambience": -1,
          "cleanliness": 0,
          "value_for_money": 1,
          "comment": "Affordable place for a casual dinner",
          "recommendation_rating" : 4
        }
      }
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      {"points" : 120}
      """
      And the outlet's rewards pool should have "1120" points
      And the user should have "220" points
      And the feedback with id "10" should have the following attributes
      |food_quality|-1|
      |speed_of_service|1|
      |friendliness_of_service|0|
      |ambience|-1|
      |cleanliness|0|
      |value_for_money|1|
      |comment|Affordable place for a casual dinner|
      |recommendation_rating|4|
      |completed|true|
      And a log entry should be created in "Feedback Log" table with following:
        |user_id|130|
        |user_first_name|Adam|
        |user_last_name|Smith|
        |user_email|user@gmail.com|
        |customer_id|100|
        |outlet_id|20|
        |feedback_id|10|
        |outlet_name|Subway - Bangalore|
        |code|12345|
        |points|120|
        |outlet_points_before|1000|
        |outlet_points_after|1120|
        |user_points_before|100|
        |user_points_after|220|

   Scenario: Successful submission of feedback of a newly registered user should have a log entry
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "20"
        And the outlet has "1000" points in its rewards pool
      Given A feedback exists with the following attributes:
        |id       |10     |
        |code     |12345  |
        |points   |120    |
        |outlet_id|20     |
        |completed|false  |
        And the time limit for giving feedback is "120" minutes
      When I send a PUT request to "/api/feedbacks/10" with the following:
      """
      {
        "feedback" : {
          "food_quality": -1,
          "speed_of_service": 1,
          "friendliness_of_service": 0,
          "ambience": -1,
          "cleanliness": 0,
          "value_for_money": 1,
          "comment": "Affordable place for a casual dinner"
        }
      }
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      {"points" : 120}
      """
      And the outlet's rewards pool should have "1000" points
      And the feedback with id "10" should belong to user with id "nil"
      And the feedback with id "10" should have the kanari code as "12345"
      And the feedback with id "10" should be completed
      And there should not be any log entry in "Feedback Log" table for feedback with id "10"
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123" and user id "130"
        And his role is "user"
        And his authentication token is "auth_token_123"
        And he has "0" points
      When I authenticate as the user "auth_token_123" with the password "random string"
      When I send a POST request to "/api/new_registration_points" with the following:
      """
      {
        "feedback_id" : 10
      }
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      {"points" : 120}
      """
      And the outlet's rewards pool should have "1120" points
      And the user should have "120" points
      And the feedback with id "10" should belong to user with id "130"
      And the feedback with id "10" should have no kanari code
      And a log entry should be created in "Feedback Log" table with following:
        |user_id|130|
        |user_first_name|Adam|
        |user_last_name|Smith|
        |user_email|user@gmail.com|
        |customer_id|100|
        |outlet_id|20|
        |feedback_id|10|
        |outlet_name|Subway - Bangalore|
        |code|12345|
        |points|120|
        |outlet_points_before|1000|
        |outlet_points_after|1120|
        |user_points_before|0|
        |user_points_after|120|
      When I authenticate as the user "auth_token_123" with the password "random string"
      When I send a POST request to "/api/new_registration_points" with the following:
      """
      {
        "feedback_id" : 10
      }
      """
      Then the response status should be "404"
      And the JSON response should be:
      """
      {"errors": ["Feedback not found."]}
      """
