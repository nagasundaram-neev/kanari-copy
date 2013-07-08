Feature: Request Redemption

    Background:
      Given I send and accept JSON

    Scenario: Successfully request redemption
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "20"
        And the outlet has "1000" points in its rewards pool
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
        And his role is "user"
        And his authentication token is "auth_token_123"
        And he has "100" points
      When I authenticate as the user "auth_token_123" with the password "random string"
      When I send a POST request to "/api/redemptions" with the following:
      """
      {
        "redemption" : {
          "outlet_id": 20,
          "points" : 90
        }
      }
      """
      Then the response status should be "201"
      And the JSON response should be:
      """
      null
      """
      And the outlet's rewards pool should have "910" points
      And the user should have "10" points

    Scenario: User doesn't have enough points
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "20"
        And the outlet has "1000" points in its rewards pool
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
        And his role is "user"
        And his authentication token is "auth_token_123"
        And he has "80" points
      When I authenticate as the user "auth_token_123" with the password "random string"
      When I send a POST request to "/api/redemptions" with the following:
      """
      {
        "redemption" : {
          "outlet_id": 20,
          "points" : 90
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      {"errors" : ["Points not available"]}
      """
      And the outlet's rewards pool should have "1000" points
      And the user should have "80" points

    Scenario: Outlet doesn't have enough points
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "20"
        And the outlet has "80" points in its rewards pool
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
        And his role is "user"
        And his authentication token is "auth_token_123"
        And he has "200" points
      When I authenticate as the user "auth_token_123" with the password "random string"
      When I send a POST request to "/api/redemptions" with the following:
      """
      {
        "redemption" : {
          "outlet_id": 20,
          "points" : 90
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      {"errors" : ["Points not available"]}
      """
      And the outlet's rewards pool should have "80" points
      And the user should have "200" points

	Scenario: Invalid Outlet
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "20"
        And the outlet has "80" points in its rewards pool
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
        And his role is "user"
        And his authentication token is "auth_token_123"
        And he has "200" points
      When I authenticate as the user "auth_token_123" with the password "random string"
      When I send a POST request to "/api/redemptions" with the following:
      """
      {
        "redemption" : {
          "outlet_id": 10,
          "points" : 90
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      {"errors" : ["Outlet is not available"]}
      """
      And the user should have "200" points

    Scenario Outline: User's role is not 'user'
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "20"
        And the outlet has "1000" points in its rewards pool
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
        And his role is "<role>"
        And his authentication token is "auth_token_123"
        And he has "100" points
      When I authenticate as the user "auth_token_123" with the password "random string"
      When I send a POST request to "/api/redemptions" with the following:
      """
      {
        "redemption" : {
          "outlet_id" : 20,
          "points" : 90
        }
      }
      """
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors": ["Insufficient privileges"]}
      """
      Examples:
      |role|
      |kanari_admin|
      |customer_admin|
      |manager|
      |staff|

    Scenario: User is not authenticated
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "20"
        And the outlet has "1000" points in its rewards pool
      When I send a POST request to "/api/redemptions" with the following:
      """
      {
        "redemption" : {
          "outlet_id" : 20,
          "points" : 90
        }
      }
      """
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors": ["Invalid login credentials"]}
      """
