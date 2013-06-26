Feature: List Outlet Types

    Background:
      Given I send and accept JSON

    Scenario: Successfully list all outlet types
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
      And the following outlet types exist
        |name               | id  |
        |Fine Dining        | 1   |
        |Casual Dining      | 2   |
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/outlet_types/1"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "outlet_type" : {"id" : 1, "name" : "Fine Dining" }
      }
      """

    Scenario: Outlet type doesn't exist
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
      And the following outlet types exist
        |name               | id  |
        |Fine Dining        | 1   |
        |Casual Dining      | 2   |
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/outlet_types/3"
      Then the response status should be "422"
      And the JSON response should be:
      """
      {
        "errors" : ["Couldn't find OutletType with id=3"]
      }
      """

    Scenario: User is not authenticated
      Given the following outlet types exist
        |name               | id  |
        |Fine Dining        | 1   |
        |Casual Dining      | 2   |
      And I send a GET request to "/api/outlet_types/1"
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors" : ["Invalid login credentials"]}
      """
