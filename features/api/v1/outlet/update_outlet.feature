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
      And he is the admin for customer "China Pearl"
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
      Then the response status should be "200"
      And the JSON response should be:
      """
      null
      """
      And the outlet "China Pearl - Bengaluru" should be present under customer with id "100"
      And the outlet should be disabled

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

    Scenario Outline: User's role is not customer_admin
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
      |manager        |
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
