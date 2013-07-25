Feature: Update Staff 

    Background:
      Given I send and accept JSON

    Scenario: Customer Admin Successfully updates staff OR tablet
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            | created_at             |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    | "2013-01-08 00:00:00"  |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  | "2013-02-08 00:00:00"  |
         |3         |Noushad    |admin@itc.com                  | password123 | noushad_auth_token    | customer_admin  | "2013-03-08 00:00:00"  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         | "2013-04-08 00:00:00"  |
         |101       |Donald     |manager@itc.com                | password123 | donald_auth_token     | manager         | "2013-05-08 00:00:00"  |
         |1000      |Ron        |staff.bangalore.1@subway.com   | password123 | ron_auth_token        | staff           | "2013-06-08 00:00:00"  |
         |1001      |John       |staff.bangalore.2@subway.com   | password123 | john_auth_token       | staff           | "2013-06-08 00:00:00"  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      Given a customer named "ITC" exists with id "200" with admin "admin@itc.com"
        And the customer with id "200" has an outlet named "ITC - Bangalore" with id "20" with manager "manager@itc.com"
      When I authenticate as the user "bill_auth_token" with the password "random string"
      And I send a PUT request to "/api/staffs/1000" with the following:
      """
      {
        "staff" : {
          "password": "test1234",
          "password_confirmation": "test1234",
          "current_password": "password123"
        }
      }
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      null
      """
    
    Scenario: Staff or Tablet not found
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            | created_at             |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    | "2013-01-08 00:00:00"  |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  | "2013-02-08 00:00:00"  |
         |3         |Noushad    |admin@itc.com                  | password123 | noushad_auth_token    | customer_admin  | "2013-03-08 00:00:00"  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         | "2013-04-08 00:00:00"  |
         |101       |Donald     |manager@itc.com                | password123 | donald_auth_token     | manager         | "2013-05-08 00:00:00"  |
         |1000      |Ron        |staff.bangalore.1@subway.com   | password123 | ron_auth_token        | staff           | "2013-06-08 00:00:00"  |
         |1001      |John       |staff.bangalore.2@subway.com   | password123 | john_auth_token       | staff           | "2013-06-08 00:00:00"  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      Given a customer named "ITC" exists with id "200" with admin "admin@itc.com"
        And the customer with id "200" has an outlet named "ITC - Bangalore" with id "20" with manager "manager@itc.com"
      When I authenticate as the user "bill_auth_token" with the password "random string"
      And I send a PUT request to "/api/staffs/2000" with the following:
      """
      {
        "staff" : {
          "password": "test1234",
          "password_confirmation": "test1234",
          "current_password": "password123"
        }
      }
      """
      Then the response status should be "404"
      And the JSON response should be:
      """
      {"errors": ["Staff record not found"]}
      """

    Scenario: Customer Admin Or Manager is not authorized: Manager of one outlet tries to update Staff or Tablet of another outlet
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            | created_at             |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    | "2013-01-08 00:00:00"  |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  | "2013-02-08 00:00:00"  |
         |3         |Noushad    |admin@itc.com                  | password123 | noushad_auth_token    | customer_admin  | "2013-03-08 00:00:00"  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         | "2013-04-08 00:00:00"  |
         |101       |Donald     |manager@itc.com                | password123 | donald_auth_token     | manager         | "2013-05-08 00:00:00"  |
         |1000      |Ron        |staff.bangalore.1@subway.com   | password123 | ron_auth_token        | staff           | "2013-06-08 00:00:00"  |
         |1001      |John       |staff.bangalore.2@subway.com   | password123 | john_auth_token       | staff           | "2013-06-08 00:00:00"  |
         |1002      |Richard    |staff.bangalore.1@itc.com   | password123 | richard_auth_token    | staff           | "2013-06-08 00:00:00"  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      Given a customer named "ITC" exists with id "200" with admin "admin@itc.com"
        And the customer with id "200" has an outlet named "ITC - Bangalore" with id "20" with manager "manager@itc.com"
        And outlet "ITC - Bangalore" has staffs
          |staff.bangalore.1@itc.com   |
      When I authenticate as the user "bill_auth_token" with the password "random string"
      And I send a PUT request to "/api/staffs/1002" with the following:
      """
      {
        "staff" : {
          "password": "test1234",
          "password_confirmation": "test1234",
          "current_password": "password123"
        }
      }
      """
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors": ["Insufficient privileges"]}
      """

  Scenario Outline: User's role is not Customer Admin Or Manager
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            | created_at             |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    | "2013-01-08 00:00:00"  |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  | "2013-02-08 00:00:00"  |
         |3         |Noushad    |admin@itc.com                  | password123 | noushad_auth_token    | customer_admin  | "2013-03-08 00:00:00"  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         | "2013-04-08 00:00:00"  |
         |101       |Donald     |manager@itc.com                | password123 | donald_auth_token     | manager         | "2013-05-08 00:00:00"  |
         |1000      |Ron        |staff.bangalore.1@subway.com   | password123 | ron_auth_token        | staff           | "2013-06-08 00:00:00"  |
         |1001      |John       |staff.bangalore.2@subway.com   | password123 | john_auth_token       | staff           | "2013-06-08 00:00:00"  |
         |1002      |Richard    |staff.bangalore.1@itc.com   | password123 | richard_auth_token    | staff           | "2013-06-08 00:00:00"  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      Given a customer named "ITC" exists with id "200" with admin "admin@itc.com"
        And the customer with id "200" has an outlet named "ITC - Bangalore" with id "20" with manager "manager@itc.com"
        And outlet "ITC - Bangalore" has staffs
          |staff.bangalore.1@itc.com   |
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "<role>"
        And his authentication token is "auth_token_1234"
      When I authenticate as the user "auth_token_1234" with the password "random string"
      And I send a PUT request to "/api/staffs/1000" with the following:
      """
      {
        "staff" : {
          "password": "test1234",
          "password_confirmation": "test1234",
          "current_password": "password123"
        }
      }
      """
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors": ["Insufficient privileges"]}
      """
      Examples:
      |role|
      |kanari_admin|
      |staff|
      |user|

  Scenario: Invalid current password
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            | created_at             |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    | "2013-01-08 00:00:00"  |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  | "2013-02-08 00:00:00"  |
         |3         |Noushad    |admin@itc.com                  | password123 | noushad_auth_token    | customer_admin  | "2013-03-08 00:00:00"  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         | "2013-04-08 00:00:00"  |
         |101       |Donald     |manager@itc.com                | password123 | donald_auth_token     | manager         | "2013-05-08 00:00:00"  |
         |1000      |Ron        |staff.bangalore.1@subway.com   | password123 | ron_auth_token        | staff           | "2013-06-08 00:00:00"  |
         |1001      |John       |staff.bangalore.2@subway.com   | password123 | john_auth_token       | staff           | "2013-06-08 00:00:00"  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      Given a customer named "ITC" exists with id "200" with admin "admin@itc.com"
        And the customer with id "200" has an outlet named "ITC - Bangalore" with id "20" with manager "manager@itc.com"
      When I authenticate as the user "bill_auth_token" with the password "random string"
      And I send a PUT request to "/api/staffs/1000" with the following:
      """
      {
        "staff" : {
          "password": "test1234",
          "password_confirmation": "test1234",
          "current_password": "invalidpassword"
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      {"errors": ["Current password is invalid"]}
      """
   
  Scenario: Password do not match
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            | created_at             |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    | "2013-01-08 00:00:00"  |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  | "2013-02-08 00:00:00"  |
         |3         |Noushad    |admin@itc.com                  | password123 | noushad_auth_token    | customer_admin  | "2013-03-08 00:00:00"  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         | "2013-04-08 00:00:00"  |
         |101       |Donald     |manager@itc.com                | password123 | donald_auth_token     | manager         | "2013-05-08 00:00:00"  |
         |1000      |Ron        |staff.bangalore.1@subway.com   | password123 | ron_auth_token        | staff           | "2013-06-08 00:00:00"  |
         |1001      |John       |staff.bangalore.2@subway.com   | password123 | john_auth_token       | staff           | "2013-06-08 00:00:00"  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      Given a customer named "ITC" exists with id "200" with admin "admin@itc.com"
        And the customer with id "200" has an outlet named "ITC - Bangalore" with id "20" with manager "manager@itc.com"
      When I authenticate as the user "bill_auth_token" with the password "random string"
      And I send a PUT request to "/api/staffs/1000" with the following:
      """
      {
        "staff" : {
          "password": "test123456",
          "password_confirmation": "test1234",
          "current_password": "password123"
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      {"errors": ["Password confirmation doesn't match Password"]}
      """
    
    Scenario: User not authenticated
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            | created_at             |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    | "2013-01-08 00:00:00"  |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  | "2013-02-08 00:00:00"  |
         |3         |Noushad    |admin@itc.com                  | password123 | noushad_auth_token    | customer_admin  | "2013-03-08 00:00:00"  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         | "2013-04-08 00:00:00"  |
         |101       |Donald     |manager@itc.com                | password123 | donald_auth_token     | manager         | "2013-05-08 00:00:00"  |
         |1000      |Ron        |staff.bangalore.1@subway.com   | password123 | ron_auth_token        | staff           | "2013-06-08 00:00:00"  |
         |1001      |John       |staff.bangalore.2@subway.com   | password123 | john_auth_token       | staff           | "2013-06-08 00:00:00"  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      When I authenticate as the user "invalid_auth_token" with the password "random string"
      And I send a PUT request to "/api/staffs/1000" with the following:
      """
      {
        "staff" : {
          "current_password": "password123",
          "password": "changed123",
          "password_confirmation": "changed123"
        }
      }
      """
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors" : ["Invalid login credentials"]}
      """
