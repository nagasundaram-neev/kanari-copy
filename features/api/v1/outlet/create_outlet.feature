Feature: Create Outlet

    Background:
      Given I send and accept JSON

    Scenario: Successfully create outlet
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "customer_admin"
        And his authentication token is "auth_token_123"
      Given a customer named "China Pearl" exists with id "100"
      And he is the admin for customer "China Pearl"
      Given "Bob" is a user with email id "bob@gmail.com" and password "password123" and user id "10"
        And his role is "manager"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a POST request to "/api/outlets" with the following:
      """
      {
        "outlet" : {
          "name" : "Batman's Donuts",
          "address" : "Dark Avenue, Gotham City",
          "latitude" : "50.50",
          "longitude" : "60.60",
          "website_url": "http://batmansdonuts.com",
          "email": "brucewayne@batmansdonuts.com",
          "phone_number": "+123456",
          "open_hours": "10:00-23:00",
          "has_delivery": true,
          "serves_alcohol" : true,
          "has_outdoor_seating" : true,
          "manager_id" : 10
        }
      }
      """
      Then the response status should be "201"
      And the JSON response should have "outlet"
      And the JSON response at "outlet" should be a Hash
      And the JSON at "outlet" should have 3 entries
      And the JSON at "outlet/id" should be a fixnum
      And the JSON at "outlet/name" should be a string
      And the JSON at "outlet/disabled" should be a boolean
      And the JSON response should be:
      """
      {"outlet" : {"id" : 1, "name" : "Batman's Donuts", "disabled": false}}
      """
      And the outlet "Batman's Donuts" should be present under customer with id "100"
      And "Batman's Donuts" should have "bob@gmail.com" as the manager

    Scenario Outline: User's role is <role>
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "<role>"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a POST request to "/api/outlets" with the following:
      """
      {
        "outlet" : {
          "name" : "Batman's Donuts",
          "address" : "Dark Avenue, Gotham City",
          "receipt_date" : "10-10-2012",
          "latitude" : "50.50",
          "longitude" : "60.60",
          "website_url": "http://batmansdonuts.com",
          "email": "brucewayne@batmansdonuts.com",
          "phone_number": "+123456",
          "open_hours": "10:00-23:00",
          "has_delivery": true,
          "serves_alcohol" : true,
          "has_outdoor_seating" : true
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
      |manager        |
      |staff          |
      |user           |

    Scenario: User is not authenticated
      Given I send a POST request to "/api/outlets" with the following:
      """
      {
        "outlet" : {
          "name" : "Batman's Donuts",
          "address" : "Dark Avenue, Gotham City",
          "receipt_date" : "10-10-2012",
          "latitude" : "50.50",
          "longitude" : "60.60",
          "website_url": "http://batmansdonuts.com",
          "email": "brucewayne@batmansdonuts.com",
          "phone_number": "+123456",
          "open_hours": "10:00-23:00",
          "has_delivery": true,
          "serves_alcohol" : true,
          "has_outdoor_seating" : true
        }
      }
      """
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors" : ["Invalid login credentials"]}
      """
