Feature: Assign points after user registration

    Background:
      Given I send and accept JSON

    Scenario: Successfully assign points
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "20"
        And the outlet has "1000" points in its rewards pool
      Given A feedback exists with the following attributes:
        |id       |10     |
        |code     |12345  |
        |points   |120    |
        |outlet_id|20     |
        |completed|true   |
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

      Scenario: User not authenticated
        When I send a POST request to "/api/new_registration_points" with the following:
        """
        {
          "feedback_id" : 10
        }
        """
        Then the response status should be "401"
        And the JSON response should be:
        """
        {"errors": ["Invalid login credentials"]}
        """

    Scenario Outline: User's role is not 'user'
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "20"
        And the outlet has "1000" points in its rewards pool
      Given A feedback exists with the following attributes:
        |id       |10     |
        |code     |12345  |
        |points   |120    |
        |outlet_id|20     |
        |completed|true   |
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
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123" and user id "130"
        And his role is "<role>"
        And his authentication token is "auth_token_123"
        And he has "0" points
      When I authenticate as the user "auth_token_123" with the password "random string"
      When I send a POST request to "/api/new_registration_points" with the following:
      """
      {
        "feedback_id" : 10
      }
      """
      Then the response status should be "403"
      And the JSON response should be:
      """
        {"errors": ["Insufficient privileges"]}
      """
      And the outlet's rewards pool should have "1000" points
      And the user should have "0" points
      And the feedback with id "10" should belong to user with id "nil"
      Examples:
      |role|
      |kanari_admin|
      |customer_admin|
      |manager|
      |staff|

