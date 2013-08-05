Feature: Update feedback

    Background:
      Given I send and accept JSON

    Scenario: Successfully update feedback
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "20"
        And the outlet has "1000" points in its rewards pool
      Given A feedback exists with the following attributes:
        |id       |10     |
        |code     |12345  |
        |points   |120    |
        |outlet_id|20     |
        |completed|true   |
        And the time limit for giving feedback is "120" minutes
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123" and user id "130"
        And his role is "user"
        And his authentication token is "auth_token_123"
        And he has "100" points
        And he is giving feedback for the first time
        And his last activity was on "2013-01-01 01:00:00"
      When I authenticate as the user "auth_token_123" with the password "random string"
      When I send a PUT request to "/api/feedbacks/10" with the following:
      """
      {
        "feedback" : {
          "user_id": 130
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
      And the feedback with id "10" should belong to user with id "130"
      And the feedback with id "10" should have no kanari code
      And the feedback with id "10" should be completed 
      And the user should have "1" feedback count
      And the user's last activity should be today

    Scenario: Successfully update feedback when user is not authenticated
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "20"
        And the outlet has "1000" points in its rewards pool
      Given A feedback exists with the following attributes:
        |id       |10     |
        |code     |12345  |
        |points   |120    |
        |outlet_id|20     |
        |completed|true   |
        And the time limit for giving feedback is "120" minutes
      When I send a PUT request to "/api/feedbacks/10" with the following:
      """
      {
        "feedback" : {
          "user_id": 130
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
