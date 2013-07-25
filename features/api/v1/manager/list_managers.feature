Feature: List Managers

    Background:
      Given I send and accept JSON

    Scenario: Successfully list all managers
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |1000      |Edward     |staff.bangalore.1@cp.com       | password123 | edward_auth_token     | staff           |
         |1001      |Julian     |staff.bangalore.2@cp.com       | password123 | julian_auth_token     | staff           |
         |1002      |Eric       |staff.bangalore.1@subway.com   | password123 | eric_auth_token       | staff           |
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
        And his role is "customer_admin"
      Given a customer named "China Pearl" exists with id "100"
        And the customer with id "100" has an outlet named "China Pearl - Bangalore"
        And the customer with id "100" has an outlet named "China Pearl - Pune"
        And the customer with id "100" has an outlet named "China Pearl - Kolkata"
        And outlet "China Pearl - Bangalore" has staffs
          |staff.bangalore.1@cp.com   |
          |staff.bangalore.2@cp.com   |
      And a customer named "Mast Kalandar" exists with id "101"
        And the customer with id "101" has an outlet named "Mast Kalandar - Bangalore"
        And the customer with id "101" has an outlet named "Mast Kalandar - Pune"
      Given he is the admin for customer "China Pearl"
      And an unassigned manager exists with the following attributes for customer 100
        |id|50|
        |first_name|Unassigned|
        |last_name|Manager|
        |email|unassigned@manager.com|
        |phone_number|1111|
        |password|password123|
        |password_confirmation|password123|
      And the following managers have been created
        |outlet_name                |   manager_id    |   first_name  | last_name   | email       | phone_number  |
        |China Pearl - Bangalore    |   10            |   John        | Smith       | john@cp.com | 1234          |
        |China Pearl - Kolkata      |   20            |   William     | Penn        | penn@cp.com | 2345          |
        |China Pearl - Pune         |   20            |   William     | Penn        | penn@cp.com | 2345          |
        |Mast Kalandar - Pune       |   30            |   Tim         | Burton      | tim@mk.com  | 3456          |
        |Mast Kalandar - Bangalore  |   40            |   Katrina     | Owen        | kat@mk.cm   | 4567          |
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/managers"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "managers" : [
          {"id" : 10, "first_name" : "John", "last_name"  : "Smith", "email" : "john@cp.com", "phone_number" : "1234"},
          {"id" : 20, "first_name" : "William", "last_name"  : "Penn", "email" : "penn@cp.com", "phone_number" : "2345"},
          {"id" : 50, "first_name" : "Unassigned", "last_name"  : "Manager", "email" : "unassigned@manager.com", "phone_number" : "1111"}
        ]
      }
      """

    Scenario: User not authenticated
      And I send a GET request to "/api/managers"
      Then the response status should be "401"
      And the JSON response should be:
      """
      { "errors" : ["Invalid login credentials"] }
      """
      And a new user should not be created with email "manager@gmail.com"


    Scenario Outline: User's role is not customer_admin
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
        And his role is "<role>"
      Given a customer named "China Pearl" exists with id "100"
        And the customer with id "100" has an outlet named "China Pearl - Bangalore"
        And the customer with id "100" has an outlet named "China Pearl - Pune"
        And the customer with id "100" has an outlet named "China Pearl - Kolkata"
      And a customer named "Mast Kalandar" exists with id "101"
        And the customer with id "101" has an outlet named "Mast Kalandar - Bangalore"
        And the customer with id "101" has an outlet named "Mast Kalandar - Pune"
      Given he is the admin for customer "China Pearl"
      And the following managers have been created
        |outlet_name                |   manager_id    |   first_name  | last_name   | email       | phone_number  |
        |China Pearl - Bangalore    |   10            |   John        | Smith       | john@cp.com | 1234          |
        |China Pearl - Kolkata      |   20            |   William     | Penn        | penn@cp.com | 2345          |
        |China Pearl - Pune         |   20            |   William     | Penn        | penn@cp.com | 2345          |
        |Mast Kalandar - Pune       |   30            |   Tim         | Burton      | tim@mk.com  | 3456          |
        |Mast Kalandar - Bangalore  |   40            |   Katrina     | Owen        | kat@mk.cm   | 4567          |
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/managers"
      Then the response status should be "403"
      And the JSON response should be:
      """
      { "errors" : ["Insufficient privileges"] }
      """
      And a new user should not be created with email "manager@gmail.com"

      Examples:
      |role           |
      |kanari_admin   |
      |manager        |
      |staff          |
      |user           |

    Scenario: User has not created a customer account yet
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
        And his role is "customer_admin"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/managers"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "managers" : []
      }
      """

    Scenario: User has not created outlet profiles
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
        And his role is "customer_admin"
      Given a customer named "China Pearl" exists with id "100"
      And a customer named "Mast Kalandar" exists with id "101"
      Given he is the admin for customer "China Pearl"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/managers"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "managers" : []
      }
      """

