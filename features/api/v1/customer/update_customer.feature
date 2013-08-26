Feature: Update Customer

    Background:
      Given I send and accept JSON

    Scenario: User's role is customer_admin
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
        |Clinton    |admin@nbc.com                  | password123 | clinton_auth_token    | customer_admin  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
      Given a customer named "Noushad the Big Chef" exists with id "101" with admin "admin@nbc.com"
      When I authenticate as the user "bill_auth_token" with the password "random string"
      And I send a PUT request to "/api/customers/100" with the following:
      """
      {
        "customer" : {
          "name" : "China Pearl",
          "email" : "newemail@gmail.com"
        }
      }
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      null
      """
      And the "name" of customer with id "100" should be "China Pearl"
      And the "email" of customer with id "100" should be "newemail@gmail.com"

    Scenario: User's role is kanari_admin
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
        |Clinton    |admin@nbc.com                  | password123 | clinton_auth_token    | customer_admin  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
      Given a customer named "Noushad the Big Chef" exists with id "101" with admin "admin@nbc.com"
      When I authenticate as the user "admin_auth_token" with the password "random string"
      And I send a PUT request to "/api/customers/100" with the following:
      """
      {
        "customer" : {
		  "authorized_outlets" : "5",
          "name" : "modified Subway"
        }
      }
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      null
      """
      And the "authorized_outlets" of customer with id "100" should be "5"
      And the "name" of customer with id "100" should be "Subway"

    Scenario: Customer belongs to a different customer_admin
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
        |Clinton    |admin@nbc.com                  | password123 | clinton_auth_token    | customer_admin  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
      Given a customer named "Noushad the Big Chef" exists with id "101" with admin "admin@nbc.com"
      When I authenticate as the user "bill_auth_token" with the password "random string"
      And I send a PUT request to "/api/customers/101" with the following:
      """
      {
        "customer" : {
          "name" : "China Pearl",
          "email" : "newemail@gmail.com"
        }
      }
      """
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors" : ["Insufficient privileges"]}
      """

    Scenario Outline: User's role is <role>
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "<role>"
        And his authentication token is "auth_token_123"
      Given "Admin" is a user with email id "admin@subway.com" and password "password123"
        And his role is "customer_admin"
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a PUT request to "/api/customers/100"
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors" : ["Insufficient privileges"]}
      """
      Examples:
        |role           |
        |manager        |
        |staff          |
        |user           |


    Scenario: User is not authenticated
      When I authenticate as the user "invalid_auth_token" with the password "random string"
      And I send a GET request to "/api/customers/100"
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors" : ["Invalid login credentials"]}
      """
