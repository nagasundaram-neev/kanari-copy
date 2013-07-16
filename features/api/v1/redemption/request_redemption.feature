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
      And the outlet's rewards pool should have "1000" points
      And the user should have "100" points

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

	Scenario: Outlet doesn't have enough points considering pending redemptions
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10"
        And the outlet has "600" points in its rewards pool
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
        And his role is "user"
        And his authentication token is "auth_token_123"
        And he has "300" points
        And the following redemptions exist
          |id           |outlet_id    |   user_id       |   points   | approved |
          |1            |10           |   1000          |   100      |   false  |
          |2            |10           |   2000          |   300      |   false  |
          |3            |10           |   3000          |   200      |   true   |
          |4            |20           |   3000          |   200      |   false  |
          |5            |30           |   1000          |   100      |   false  |
      When I authenticate as the user "auth_token_123" with the password "random string"
      When I send a POST request to "/api/redemptions" with the following:
      """
      {
        "redemption" : {
          "outlet_id": 10,
          "points" : 300
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      {"errors" : ["Points not available"]}
      """
      And the outlet's rewards pool should have "600" points
      And the user should have "300" points

	Scenario: Outlet have just enough points with considering pending redemptions
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10"
        And the outlet has "600" points in its rewards pool
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
        And his role is "user"
        And his authentication token is "auth_token_123"
        And he has "200" points
        And the following redemptions exist
          |id           |outlet_id    |   user_id       |   points   | approved |
          |1            |10           |   1000          |   100      |   false  |
          |2            |10           |   2000          |   300      |   false  |
          |3            |10           |   3000          |   200      |   true   |
          |4            |20           |   3000          |   200      |   false  |
          |5            |30           |   1000          |   100      |   false  |
      When I authenticate as the user "auth_token_123" with the password "random string"
      When I send a POST request to "/api/redemptions" with the following:
      """
      {
        "redemption" : {
          "outlet_id": 10,
          "points" : 200
        }
      }
	  """
      Then the response status should be "201"
      And the JSON response should be:
      """
      null
      """
      And the outlet's rewards pool should have "600" points
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
      Then the response status should be "404"
      And the JSON response should be:
      """
      {"errors" : ["Outlet not found."]}
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
