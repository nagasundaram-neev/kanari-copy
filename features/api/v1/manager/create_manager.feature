Feature: Create Manager

    Background:
      Given I send and accept JSON

    Scenario: Successfully create a manager
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "customer_admin"
        And his authentication token is "auth_token_123"
      Given a customer named "Subway" exists with id "100" with admin "user@gmail.com"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a POST request to "/api/managers" with the following:
      """
      {
        "user" : {
          "email" : "manager@gmail.com",
          "first_name" : "John",
          "last_name" : "Doe",
          "phone_number" : "+9132222",
          "password" : "password123",
          "password_confirmation" : "password123"
        }
      }
      """
      Then the response status should be "201"
      And the JSON response should be:
      """
      { "manager" : { "id" : 1  } }
      """
      And a new user with email "manager@gmail.com" should be created
      And the user's full name should be "John Doe"
      And the user's phone number should be "+9132222"
      And his password should be "password123"
      And he should be under customer id "100"

    Scenario: User not authenticated
      And I send a POST request to "/api/managers" with the following:
      """
      {
        "user" : {
          "email" : "manager@gmail.com",
          "first_name" : "John",
          "last_name" : "Doe",
          "phone_number" : "+9132222",
          "password" : "password123",
          "password_confirmation" : "password123"
        }
      }
      """
      Then the response status should be "401"
      And the JSON response should be:
      """
      { "errors" : ["Invalid login credentials"] }
      """
      And a new user should not be created with email "manager@gmail.com"

    Scenario: Passwords do not match
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "customer_admin"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a POST request to "/api/managers" with the following:
      """
      {
        "user" : {
          "email" : "manager@gmail.com",
          "first_name" : "John",
          "last_name" : "Doe",
          "phone_number" : "+9132222",
          "password" : "password123",
          "password_confirmation" : "password1234"
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      { "errors" : ["Password confirmation doesn't match Password"] }
      """
      And a new user should not be created with email "manager@gmail.com"

    Scenario Outline: User's role is not customer_admin
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "<role>"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a POST request to "/api/managers" with the following:
      """
      {
        "user" : {
          "email" : "manager@gmail.com",
          "first_name" : "John",
          "last_name" : "Doe",
          "phone_number" : "+9132222",
          "password" : "password123",
          "password_confirmation" : "password123"
        }
      }
      """
      Then the response status should be "403"
      And the JSON response should be:
      """
      { "errors" : ["Insufficient privileges"] }
      """
      And a new user should not be created with email "manager@gmail.com"

      Examples:
      |role           |
      |kanari_admin   |
      |manager        |
      |staff          |
      |user           |
