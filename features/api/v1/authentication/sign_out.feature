Feature: Sign Out

    Background:
      Given I send and accept JSON

    Scenario: Successful sign out using auth_token in HTTP basic auth
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "kanari_admin"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_123" with the password "X"
      And I send a DELETE request to "/api/users/sign_out"
      Then the response status should be "200"
      And the JSON response should be:
      """
      null
      """
      And the auth_token should be different from "auth_token_123"

    Scenario: Successful sign out using auth_token in params
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "kanari_admin"
        And his authentication token is "auth_token_123"
      And I send a DELETE request to "/api/users/sign_out" with the following:
      """
      {
        "auth_token" : "auth_token_123"
      }
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      null
      """
      And the auth_token should be different from "auth_token_123"

    Scenario: Invalid auth_token
      When I authenticate as the user "auth_token_1234" with the password "X"
      And I send a DELETE request to "/api/users/sign_out" with the following:
      Then the response status should be "401"
      And the JSON response should be:
      """
      {
        "errors" : ["Invalid login credentials"]
      }
      """

    Scenario: No auth_token is passed
      And I send a DELETE request to "/api/users/sign_out" with the following:
      Then the response status should be "401"
      And the JSON response should be:
      """
      {
        "errors" : ["Invalid login credentials"]
      }
      """
