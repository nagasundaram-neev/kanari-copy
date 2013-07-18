Feature: Create Feedback

    Background:
      Given I send and accept JSON

    Scenario: Successful feedback by registered user
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "20"
        And the outlet has "1000" points in its rewards pool
      Given A feedback exists with the following attributes:
        |id       |10     |
        |code     |12345  |
        |points   |120    |
        |outlet_id|20      |
        And the time limit for giving feedback is "120" minutes
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
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

    Scenario: User not authenticated
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "20"
        And the outlet has "1000" points in its rewards pool
      Given A feedback exists with the following attributes:
        |id       |10     |
        |code     |12345  |
        |points   |120    |
        |outlet_id|20      |
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
      And the feedback with id "10" should have the following attributes
      |food_quality|-1|
      |speed_of_service|1|
      |friendliness_of_service|0|
      |ambience|-1|
      |cleanliness|0|
      |value_for_money|1|
      |comment|Affordable place for a casual dinner|
      |recommendation_rating||

    Scenario: Time for leaving feedback has been expired
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "20"
        And the outlet has "1000" points in its rewards pool
      Given A feedback exists with the following attributes:
        |id       |10     |
        |code     |12345  |
        |points   |120    |
        |outlet_id|20     |
        And the time limit for giving feedback is "120" minutes
        And the time for giving feedback has been expired
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
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
          "comment": "Affordable place for a casual dinner"
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      { "errors" : ["Sorry, time for giving feedback has been expired! You were supposed to give feedback within 120 minutes"] }
      """
      And the outlet's rewards pool should have "1000" points
      And the user should have "100" points
      And the feedback with id "10" should not be completed
      And the feedback with id "10" should have kanari code

    Scenario: Feedback doesn't exist
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "20"
        And the outlet has "1000" points in its rewards pool
      Given there exists no feedback with id "10"
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
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
          "comment": "Affordable place for a casual dinner"
        }
      }
      """
      Then the response status should be "404"
      And the JSON response should be:
      """
      { "errors" : ["Feedback not found."] }
      """
      And the outlet's rewards pool should have "1000" points
      And the user should have "100" points

    Scenario Outline: User's role is not 'user'
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "20"
        And the outlet has "1000" points in its rewards pool
      Given A feedback exists with the following attributes:
        |id       |10     |
        |code     |12345  |
        |points   |120    |
        |outlet_id|20      |
        And the time limit for giving feedback is "120" minutes
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
        And his role is "<role>"
        And his authentication token is "auth_token_123"
        And he has "100" points
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a PUT request to "/api/feedbacks/10" with the following:
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
          "recommendation_rating" : 2
        }
      }
      """
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
