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
      Given the following cuisine types exist
        |id   |name     |
        |1    |Indian   |
        |2    |Chinese  |
        |3    |Japanese |
      And the following outlet types exist
        |id   |name     |
        |1    |Casual   |
        |2    |Date     |
        |3    |Sports   |
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
          "manager_id" : 10,
          "cuisine_type_ids" : [1,2],
          "outlet_type_ids" : [1,3]
        }
      }
      """
      Then the response status should be "201"
      And the JSON response should have "outlet"
      And the JSON response at "outlet" should be a Hash
      And the JSON at "outlet/id" should be a fixnum
      And the JSON at "outlet/name" should be a string
      And the JSON response should be:
      """
      {
        "outlet" : {
          "name": "Batman's Donuts",
          "address": "Dark Avenue, Gotham City",
           "disabled": false,
          "email": "brucewayne@batmansdonuts.com",
          "has_delivery": true,
          "has_outdoor_seating": true,
          "latitude": 50.5,
          "longitude": 60.6,
          "manager": {
            "email": "bob@gmail.com",
            "first_name": null,
            "last_name": null,
            "phone_number": null
          },
          "open_hours": "10:00-23:00",
          "phone_number": "+123456",
          "serves_alcohol": true,
          "website_url": "http://batmansdonuts.com",
          "cuisine_types" : [
            {
              "id" : 1,
              "name" : "Indian"
            },
            {
              "id" : 2,
              "name" : "Chinese"
            }
          ],
          "outlet_types" : [
            {
              "id" : 1,
              "name" : "Casual"
            },
            {
              "id" : 3,
              "name" : "Sports"
            }
          ]
        }
      }
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
