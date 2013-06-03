Feature: List Cuisine Types

    Background:
      Given I send and accept JSON

    Scenario: Successfully list all cuisine types
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
      And the following cuisine types exist
        |name         | id  |
        |Chinese      | 1   |
        |Italian      | 2   |
        |Indian       | 3   |
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/cuisine_types"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "cuisine_types" : [
          {"id" : 1, "name" : "Chinese" },
          {"id" : 2, "name" : "Italian" },
          {"id" : 3, "name" : "Indian" }
        ]
      }
      """

    Scenario: User is not authenticated
      Given the following cuisine types exist
        |name         | id  |
        |Chinese      | 1   |
        |Italian      | 2   |
        |Indian       | 3   |
      And I send a GET request to "/api/cuisine_types"
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors" : ["Invalid login credentials"]}
      """
