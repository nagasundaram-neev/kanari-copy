Feature: Create Outlet Type

    Background:
      Given I send and accept JSON

    Scenario: Successfully create an Outlet Type
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "kanari_admin"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a POST request to "/api/outlet_types" with the following:
      """
      {
        "outlet_type" : {
          "name" : "New Outlet Type"
        }
      }
      """
      Then the response status should be "201"
      And the JSON response should be:
      """
      { "outlet_type" : { "id" : 1, "name": "New Outlet Type"  } }
      """
      And an outlet type with name "New Outlet Type" should exist

    Scenario Outline: User's role is not kanari_admin
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "<role>"
        And his authentication token is "auth_token_1234"
      When I authenticate as the user "auth_token_1234" with the password "random string"
      And I send a POST request to "/api/outlet_types" with the following:
      """
      {
        "outlet_type" : {
          "name" : "New Outlet Type"
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
      When I send a POST request to "/api/outlet_types" with the following:
      """
      {
        "outlet_type" : {
          "name" : "New Outlet Type"
        }
      }
      """
      Then the response status should be "401"
      And the JSON response should be:
      """
      { "errors" : ["Invalid login credentials"] }
      """
