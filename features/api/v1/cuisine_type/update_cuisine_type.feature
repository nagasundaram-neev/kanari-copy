Feature: Update Cuisine Type

    Background:
      Given I send and accept JSON

    Scenario: Successfully update user account
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123" and user id "130"
        And his role is "kanari_admin"
        And his authentication token is "auth_token_123"
      And the following cuisine types exist
        |name               | id  |
        |Fine Dining        | 1   |
        |Casual Dining      | 2   |
      When I authenticate as the user "auth_token_123" with the password "random string"
      When I send a PUT request to "/api/cuisine_types/2" with the following:
      """
      {
        "cuisine_type" : {
          "name": "Very Casual Dining"
        }
      }
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      null
      """
      And a cuisine type with name "Very Casual Dining" should exist

    Scenario: cuisine type doesn't exist
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123" and user id "130"
        And his role is "kanari_admin"
        And his authentication token is "auth_token_123"
      And the following cuisine types exist
        |name               | id  |
        |Fine Dining        | 1   |
        |Casual Dining      | 2   |
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a PUT request to "/api/cuisine_types/3" with the following:
      """
      {
        "cuisine_type" : {
          "name": "Very Casual Dining"
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      {
        "errors" : ["Couldn't find CuisineType with id=3"]
      }
      """

    Scenario Outline: User's role is not kanari_admin
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "<role>"
        And his authentication token is "auth_token_1234"
      And the following cuisine types exist
        |name               | id  |
        |Fine Dining        | 1   |
        |Casual Dining      | 2   |
      When I authenticate as the user "auth_token_1234" with the password "random string"
      And I send a PUT request to "/api/cuisine_types/2" with the following:
      """
      {
        "cuisine_type" : {
          "name" : "New cuisine Type"
        }
      }
      """
      Then the response status should be "403"
      And the JSON response should be:
      """
      { "errors" : ["Insufficient privileges"] }
      """
      Examples:
      |role|
      |customer_admin|
      |manager|
      |staff|
      |user|

    Scenario: User is not authenticated
      When I send a PUT request to "/api/cuisine_types/2" with the following:
      """
      {
        "cuisine_type" : {
          "name" : "New cuisine Type"
        }
      }
      """
      Then the response status should be "401"
      And the JSON response should be:
      """
      { "errors" : ["Invalid login credentials"] }
      """
