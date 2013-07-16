Feature: Create Staff

    Background:
      Given I send and accept JSON

    Scenario: Customer Admin Successfully create a staff
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "customer_admin"
        And his authentication token is "auth_token_123"
      Given a customer named "Subway" exists with id "100" with admin "user@gmail.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a POST request to "/api/staffs" with the following:
      """
      {
        "user" : {
          "password" : "password123",
          "password_confirmation" : "password123",
          "outlet_id": 10
        }
      }
      """
      Then the response status should be "201"
      And the JSON response should be a hash
      And the JSON response should have 2 keys
      And a staff should be created for outlet "10" and customer "100"
      Given I keep the JSON response at "staff_id" as "STAFF_ID"
      Then the contents of %{STAFF_ID} should be the last staff's id
      Given I keep the JSON response at "tablet_id" as "TABLET_ID"
      Then the contents of %{TABLET_ID} should be the last created tablet id
	
	Scenario: Manager Successfully create a staff
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "manager"
        And his authentication token is "auth_token_123"
      Given a customer named "Subway" exists with id "100" with admin "user@gmail.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "user@gmail.com"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a POST request to "/api/staffs" with the following:
      """
      {
        "user" : {
          "password" : "password123",
          "password_confirmation" : "password123",
          "outlet_id": 10
        }
      }
      """
      Then the response status should be "201"
      And the JSON response should have "staff_id"
      And a staff should be created for outlet "10" and customer "100"
      Given I keep the JSON response at "staff_id" as "STAFF_ID"
      Then the contents of %{STAFF_ID} should be the last staff's id
      Given I keep the JSON response at "tablet_id" as "TABLET_ID"
      Then the contents of %{TABLET_ID} should be the last created tablet id

    Scenario: Outlet is not managed by the manager
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "manager"
        And his authentication token is "auth_token_123"
      Given a customer named "Subway" exists with id "100" with admin "user@gmail.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "user@gmail.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "11"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a POST request to "/api/staffs" with the following:
      """
      {
        "user" : {
          "password" : "password123",
          "password_confirmation" : "password123",
          "outlet_id": 11
        }
      }
      """
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors" : ["Insufficient privileges"]}
      """

    Scenario: User not authenticated
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "manager"
        And his authentication token is "auth_token_1234"
      Given a customer named "Subway" exists with id "100" with admin "user@gmail.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "user@gmail.com"
      And I send a POST request to "/api/staffs" with the following:
      """
      {
        "user" : {
          "password" : "password123",
          "password_confirmation" : "password123",
          "outlet_id": 11
        }
      }
      """
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors": ["Invalid login credentials"]}
      """

    Scenario Outline: User's role is not manager or Customer Admin
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "<role>"
        And his authentication token is "auth_token_123"
      Given a customer named "Subway" exists with id "100" with admin "user@gmail.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "user@gmail.com"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a POST request to "/api/staffs" with the following:
      """
      {
        "user" : {
          "password" : "password123",
          "password_confirmation" : "password123",
          "outlet_id": 10
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
      |staff          |
      |user           |
