Feature: Show Cuisine Types

    Background:
      Given I send and accept JSON

    Scenario: Successfully list all cuisine types
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
      And the following cuisine types exist
        |name               | id  |
        |Indian Cuisine     | 1   |
        |Chinese Cuisine    | 2   |
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/cuisine_types/1"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "cuisine_type" : {"id" : 1, "name" : "Indian Cuisine" }
      }
      """

    Scenario: cuisine type doesn't exist
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
      And the following cuisine types exist
        |name               | id  |
        |Indian Cuisine     | 1   |
        |Chinese Cuisine    | 2   |
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/cuisine_types/3"
      Then the response status should be "422"
      And the JSON response should be:
      """
      {
        "errors" : ["Couldn't find CuisineType with id=3"]
      }
      """

    Scenario: User is not authenticated
      Given the following cuisine types exist
        |name               | id  |
        |Indian Cuisine     | 1   |
        |Chinese Cuisine    | 2   |
      And I send a GET request to "/api/cuisine_types/1"
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors" : ["Invalid login credentials"]}
      """
