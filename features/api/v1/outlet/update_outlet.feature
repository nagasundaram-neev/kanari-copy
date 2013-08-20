Feature: Update Outlet

    Background:
      Given I send and accept JSON

    Scenario: Successfully update an outlet
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "customer_admin"
        And his authentication token is "auth_token_123"
      Given a customer named "China Pearl" exists with id "100"
        And the customer with id "100" has an outlet named "China Pearl - Bangalore"
        And the outlet's id is "20"
        And the outlet's email is "outlet@outlet.com"
        And he is the admin for customer "China Pearl"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a PUT request to "/api/outlets/20" with the following:
      """
      {
        "outlet" : {
          "name" : "China Pearl - Bengaluru",
          "latitude": 12.97,
          "longitude": "77.61"
        }
      }
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      null
      """
      And the outlet "China Pearl - Bengaluru" should be present under customer with id "100"
      And the outlet's email should still be "outlet@outlet.com"
      And the outlet's latitude and longitude should be "12.97" and "77.61"
      And the outlet should be enabled

    Scenario: Manager successfully update an outlet
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |101       |Donald     |manager@chinapearl.com         | password123 | donald_auth_token     | manager         |
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "customer_admin"
        And his authentication token is "auth_token_123"
      Given a customer named "China Pearl" exists with id "100"
        And the customer with id "100" has an outlet named "China Pearl - Bangalore" with manager "manager@chinapearl.com"
        And the outlet's id is "20"
        And the outlet's email is "outlet@outlet.com"
        And he is the admin for customer "China Pearl"
      When I authenticate as the user "donald_auth_token" with the password "random string"
      And I send a PUT request to "/api/outlets/20" with the following:
      """
      {
        "outlet" : {
          "name" : "China Pearl - Bengaluru",
          "latitude": 12.97,
          "longitude": "77.61"
        }
      }
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      null
      """
      And the outlet "China Pearl - Bengaluru" should be present under customer with id "100"
      And the outlet's email should still be "outlet@outlet.com"
      And the outlet's latitude and longitude should be "12.97" and "77.61"
      And the outlet should be enabled

    Scenario: Update manager
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |id |
        |Adam       |admin@subway.com               | password123 | adam_auth_token       | customer_admin  |1  |
        |Bill       |bill@subway.com                | password123 | bill_auth_token       | manager         |2  |
        |Noushad    |noushad@subway.com             | password123 | noushad_auth_token    | manager         |3  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with manager "bill@subway.com"
        And the outlet's id is "20"
      Then "Subway - Bangalore" should have "bill@subway.com" as the manager
      When I authenticate as the user "adam_auth_token" with the password "random string"
      And I send a PUT request to "/api/outlets/20" with the following:
      """
      {
        "outlet" : {
          "manager_id" : 3
        }
      }
      """
      And the JSON response should be:
      """
      null
      """
      And "Subway - Bangalore" should have "noushad@subway.com" as the manager

    Scenario: Update cuisine type and outlet type
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "customer_admin"
        And his authentication token is "auth_token_123"
      Given a customer named "China Pearl" exists with id "100"
        And the customer with id "100" has an outlet named "China Pearl - Bangalore"
        And the outlet's id is "20"
      And he is the admin for customer "China Pearl"
      Given the following cuisine types exist
        |id   |name     |
        |1    |Indian   |
        |2    |Chinese  |
        |3    |Japanese |
      And the following outlet types exist
        |id   |name     |
        |1    |Casual   |
        |2    |Date     |
        |3    |Sports   |
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a PUT request to "/api/outlets/20" with the following:
      """
      {
        "outlet" : {
          "name" : "China Pearl - Bengaluru",
          "cuisine_type_ids" : [1,2],
          "outlet_type_ids" : [1,3]
        }
      }
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      null
      """
      And the outlet "China Pearl - Bengaluru" should be present under customer with id "100"
      And the outlet's cuisine types should be "Indian,Chinese"
      And the outlet's outlet types should be "Casual,Sports"

    Scenario: Outlet doesn't exist
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "customer_admin"
        And his authentication token is "auth_token_123"
      Given a customer named "China Pearl" exists with id "100"
        And the customer with id "100" has an outlet named "China Pearl - Bangalore"
        And the outlet's id is "20"
      And he is the admin for customer "China Pearl"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a PUT request to "/api/outlets/21" with the following:
      """
      {
        "outlet" : {
          "name" : "China Pearl - Bengaluru"
        }
      }
      """
      Then the response status should be "404"
      And the JSON response should be:
      """
      { "errors" : ["Outlet not found"] }
      """

    Scenario: Outlet is disabled
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "customer_admin"
        And his authentication token is "auth_token_123"
      Given a customer named "China Pearl" exists with id "100"
        And the customer with id "100" has an outlet named "China Pearl - Bangalore"
        And the outlet's id is "20"
        And the outlet's email is "outlet@outlet.com"
        And the outlet is disabled
        And he is the admin for customer "China Pearl"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a PUT request to "/api/outlets/20" with the following:
      """
      {
        "outlet" : {
          "name" : "China Pearl - Bengaluru",
          "latitude": 12.97,
          "longitude": "77.61"
        }
      }
      """
      Then the response status should be "404"
      And the JSON response should be:
      """
      { "errors" : ["Outlet not found"] }
      """
	
	Scenario: Outlet belongs to a different customer account
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "customer_admin"
        And his authentication token is "auth_token_123"
      Given a customer named "China Pearl" exists with id "100"
      Given a customer named "Mast Kalandar" exists with id "101"
        And the customer with id "100" has an outlet named "China Pearl - Bangalore"
        And the outlet's id is "20"
      And he is the admin for customer "Mast Kalandar"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a PUT request to "/api/outlets/20" with the following:
      """
      {
        "outlet" : {
          "name" : "China Pearl - Bengaluru",
          "disabled" : true
        }
      }
      """
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors" : ["Insufficient privileges"]}
      """

    Scenario Outline: User's role is not customer_admin or manager
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "<role>"
        And his authentication token is "auth_token_123"
      Given a customer named "China Pearl" exists with id "100"
        And the customer with id "100" has an outlet named "China Pearl - Bangalore"
        And the outlet's id is "20"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a PUT request to "/api/outlets/20" with the following:
      """
      {
        "outlet" : {
          "name" : "China Pearl - Bengaluru",
          "disabled" : true
        }
      }
      """
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors" : ["Insufficient privileges"]}
      """

      Examples:
      |role           |
      |kanari_admin   |
      |staff          |
      |user           |

    Scenario: User is not authenticated
      When I send a PUT request to "/api/outlets/20" with the following:
      """
      {
        "outlet" : {
          "name" : "China Pearl - Bengaluru",
          "disabled" : true
        }
      }
      """
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors" : ["Invalid login credentials"]}
      """
