Feature: Reset password

    Background:
      Given I send and accept JSON

    Scenario: Successfully reset password
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "kanari_admin"
        And his authentication token is "auth_token_123"
        And his reset_password_token is "reset_token_123"
      And I send a PUT request to "/api/users/password" with the following:
      """
      {
        "user" : {
          "reset_password_token" : "reset_token_123",
          "password" : "password1234",
          "password_confirmation" : "password1234"
        }
      }
      """
      Then the response status should be "200"
      And the JSON response should have "auth_token"
        And the auth_token should be different from "auth_token_123"
      And the JSON response at "user_role" should be "kanari_admin"
      And his password should be "password1234"

    Scenario: Invalid reset token
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "kanari_admin"
        And his authentication token is "auth_token_123"
        And his reset_password_token is "reset_token_1234"
      And I send a PUT request to "/api/users/password" with the following:
      """
      {
        "user" : {
          "reset_password_token" : "reset_token_123",
          "password" : "password1234",
          "password_confirmation" : "password1234"
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      {
        "errors" : ["Reset password token is invalid"]
      }
      """
      And his password should be "password123"

    Scenario: Passwords do not match
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "kanari_admin"
        And his authentication token is "auth_token_123"
        And his reset_password_token is "reset_token_1234"
      And I send a PUT request to "/api/users/password" with the following:
      """
      {
        "user" : {
          "reset_password_token" : "reset_token_1234",
          "password" : "password1235",
          "password_confirmation" : "password1234"
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      {
        "errors" : ["Password confirmation doesn't match Password"]
      }
      """
      And his password should be "password123"

    Scenario: Passwords are empty
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "kanari_admin"
        And his authentication token is "auth_token_123"
        And his reset_password_token is "reset_token_1234"
      And I send a PUT request to "/api/users/password" with the following:
      """
      {
        "user" : {
          "reset_password_token" : "reset_token_1234",
          "password" : "",
          "password_confirmation" : ""
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      {
        "errors" : ["Password can't be blank"]
      }
      """
      And his password should be "password123"

    Scenario: Passwords are not passed
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "kanari_admin"
        And his authentication token is "auth_token_123"
        And his reset_password_token is "reset_token_1234"
      And I send a PUT request to "/api/users/password" with the following:
      """
      {
        "user" : {
          "reset_password_token" : "reset_token_1234"
        }
      }
      """
      Then the response status should be "200"
      And the JSON response should have "auth_token"
        And the auth_token should be different from "auth_token_123"
      And the JSON response at "user_role" should be "kanari_admin"
      And his password should be "password123"

    Scenario: Reset password token is expired
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "kanari_admin"
        And his authentication token is "auth_token_123"
        And his reset_password_token is "reset_token_1234"
        But his reset_password_token is more than "6" hours old
      And I send a PUT request to "/api/users/password" with the following:
      """
      {
        "user" : {
          "reset_password_token" : "reset_token_1234"
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      {
        "errors" : ["Reset password token has expired, please request a new one"]
      }
      """
      And his password should be "password123"
