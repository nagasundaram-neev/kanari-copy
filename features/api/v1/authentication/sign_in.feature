Feature: Sign In

    Background:
      Given I send and accept JSON

    Scenario: Successful sign in
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "kanari_admin"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "user@gmail.com" with the password "password123"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "200"
      And the JSON response should have "auth_token"
        And the auth_token should be different from "auth_token_123"
      And the JSON response at "user_role" should be "kanari_admin"

    Scenario: Invalid email
      Given No user is present with email "user@gmail.com"
      When I authenticate as the user "user@gmail.com" with the password "password123"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "401"
      And the JSON response should be:
      """
      {
        "errors": ["Invalid login credentials."]
      }
      """

    Scenario: Invalid password
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
      When I authenticate as the user "user@gmail.com" with the password "password1234"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "401"
      And the JSON response should be:
      """
      {
        "errors" : ["Invalid login credentials."]
      }
      """
