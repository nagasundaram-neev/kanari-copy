Feature: Create customer account

    Background:
      Given I send and accept JSON

    Scenario: Successfully create customer account
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "customer_admin"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a POST request to "/api/customers" with the following:
      """
      {
        "customer" : {
          "name" : "Sherlock Holmes Inc.",
          "phone_number" : "+12345",
          "registered_address_line_1" : "221 B",
          "registered_address_line_2" : "Baker Street",
          "registered_address_city" : "London",
          "registered_address_country" : "United Kingdom",
          "mailing_address_line_1" : "221 B",
          "mailing_address_line_2" : "Baker Street",
          "mailing_address_city" : "London",
          "mailing_address_country" : "United Kingdom",
          "email" : "sherlock@holmes.com"
        }
      }
      """
      Then the response status should be "201"
      And the JSON response should be:
      """
      null
      """

    Scenario: User not authenticated
      And I send a POST request to "/api/customers" with the following:
      """
      {
        "customer" : {
          "name" : "Sherlock Holmes Inc.",
          "phone_number" : "+12345",
          "registered_address_line_1" : "221 B",
          "registered_address_line_2" : "Baker Street",
          "registered_address_city" : "London",
          "registered_address_country" : "United Kingdom",
          "mailing_address_line_1" : "221 B",
          "mailing_address_line_2" : "Baker Street",
          "mailing_address_city" : "London",
          "mailing_address_country" : "United Kingdom",
          "email" : "sherlock@holmes.com"
        }
      }
      """
      Then the response status should be "401"
      And the JSON response should be:
      """
      {
        "errors" : ["Invalid login credentials"]
      }
      """

    Scenario Outline: User's role is <role>
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "<role>"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a POST request to "/api/customers" with the following:
      """
      {
        "customer" : {
          "name" : "Sherlock Holmes Inc.",
          "phone_number" : "+12345",
          "registered_address_line_1" : "221 B",
          "registered_address_line_2" : "Baker Street",
          "registered_address_city" : "London",
          "registered_address_country" : "United Kingdom",
          "mailing_address_line_1" : "221 B",
          "mailing_address_line_2" : "Baker Street",
          "mailing_address_city" : "London",
          "mailing_address_country" : "United Kingdom",
          "email" : "sherlock@holmes.com"
        }
      }
      """
      Then the response status should be "201"
      And the JSON response should be:
      """
      null
      """

      Examples:
      |role           |
      |customer_admin |

    Scenario Outline: User's role is <role>
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "<role>"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a POST request to "/api/customers" with the following:
      """
      {
        "customer" : {
          "name" : "Sherlock Holmes Inc.",
          "phone_number" : "+12345",
          "registered_address_line_1" : "221 B",
          "registered_address_line_2" : "Baker Street",
          "registered_address_city" : "London",
          "registered_address_country" : "United Kingdom",
          "mailing_address_line_1" : "221 B",
          "mailing_address_line_2" : "Baker Street",
          "mailing_address_city" : "London",
          "mailing_address_country" : "United Kingdom",
          "email" : "sherlock@holmes.com"
        }
      }
      """
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors" : ["Insufficient privileges"] }
      """

      Examples:
      |role           |
      |kanari_admin   |
      |manager        |
      |staff          |
      |user           |
