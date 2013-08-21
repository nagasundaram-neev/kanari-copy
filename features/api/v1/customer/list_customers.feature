Feature: List customer accounts

    Background:
      Given I send and accept JSON

    Scenario: Successfully create customer account
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "kanari_admin"
        And his authentication token is "auth_token_123"
      Given a customer named "Subway" exists with id "100"
      And a customer named "McD" exists with id "101"
      And a customer named "KFC" exists with id "102"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/customers" with the following:
      Then the response status should be "200"
      And the JSON response should be:
      """
       {
         "customers": [
           {
            "customer_admin": null,
            "email": null,
            "authorized_outlets": 1,
            "mailing_address_city": null,
            "mailing_address_country": null,
            "mailing_address_line_1": null,
            "mailing_address_line_2": null,
            "name": "Subway",
            "phone_number": null,
            "registered_address_city": null,
            "registered_address_country": null,
            "registered_address_line_1": null,
            "registered_address_line_2": null
          },
          {
            "customer_admin": null,
            "email": null,
            "authorized_outlets": 1,
            "mailing_address_city": null,
            "mailing_address_country": null,
            "mailing_address_line_1": null,
            "mailing_address_line_2": null,
            "name": "McD",
            "phone_number": null,
            "registered_address_city": null,
            "registered_address_country": null,
            "registered_address_line_1": null,
            "registered_address_line_2": null
          },
          {
            "customer_admin": null,
            "email": null,
            "authorized_outlets": 1,
            "mailing_address_city": null,
            "mailing_address_country": null,
            "mailing_address_line_1": null,
            "mailing_address_line_2": null,
            "name": "KFC",
            "phone_number": null,
            "registered_address_city": null,
            "registered_address_country": null,
            "registered_address_line_1": null,
            "registered_address_line_2": null
           }
         ]
       }
      """

    Scenario: User not authenticated
      When I send a GET request to "/api/customers"
      Then the response status should be "401"
      And the JSON response should be:
      """
      {
        "errors" : ["Invalid login credentials"]
      }
      """

    Scenario: User's role is customer_admin
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
      When I authenticate as the user "bill_auth_token" with the password "random string"
      And I send a GET request to "/api/customers"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "customer": {
          "id" : 100,
          "customer_admin": {
            "email": "admin@subway.com",
            "first_name": "Bill",
            "last_name": null,
            "phone_number": null
          },
          "email": null,
          "authorized_outlets": 1,
          "mailing_address_city": null,
          "mailing_address_country": null,
          "mailing_address_line_1": null,
          "mailing_address_line_2": null,
          "name": "Subway",
          "phone_number": null,
          "registered_address_city": null,
          "registered_address_country": null,
          "registered_address_line_1": null,
          "registered_address_line_2": null
        }
      }
      """

    Scenario Outline: User's role is not kanari_admin
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "<role>"
        And his authentication token is "auth_token_123"
      Given a customer named "Subway" exists with id "100"
      And a customer named "McD" exists with id "101"
      And a customer named "KFC" exists with id "102"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/customers"
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors" : ["Insufficient privileges"]}
      """
      Examples:
      |role           |
      |manager |
      |staff |
      |user |
