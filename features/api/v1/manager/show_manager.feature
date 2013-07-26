Feature: Show a Manager 

    Background:
      Given I send and accept JSON

    Scenario: Customer Admin Successfully get a manager details
      Given the following users exist
         |id        |first_name |last_name |email                          | password    | authentication_token  | role            | phone_number    |
         |1         |Adam       |Bell       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    | +12345678      |
         |2         |Bill       |Clinton    |admin@subway.com               | password123 | bill_auth_token       | customer_admin  | +23456789      |
         |3         |Noushad    |Ali        |admin@itc.com                  | password123 | noushad_auth_token    | customer_admin  | +12345643      |
         |100       |George     |Potter     |manager@subway.com             | password123 | george_auth_token     | manager         | +12345645      |
         |101       |Donald     |Atkinson   |manager@itc.com                | password123 | donald_auth_token     | manager         | +12345675      |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
      Given a customer named "ITC" exists with id "200" with admin "admin@itc.com"
        And the customer with id "200" has an outlet named "ITC - Bangalore" with id "20" with manager "manager@itc.com"
      When I authenticate as the user "bill_auth_token" with the password "random string"
      And I send a GET request to "/api/managers/100"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "manager": {
          "id": "100",
          "email": "manager@subway.com",
          "first_name": "George",
          "last_name": "Potter",
          "phone_number": "+12345645"
        }
      } 
      """
    
   Scenario: Manager not found
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            | created_at             |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    | "2013-01-08 00:00:00"  |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  | "2013-02-08 00:00:00"  |
         |3         |Noushad    |admin@itc.com                  | password123 | noushad_auth_token    | customer_admin  | "2013-03-08 00:00:00"  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         | "2013-04-08 00:00:00"  |
         |101       |Donald     |manager@itc.com                | password123 | donald_auth_token     | manager         | "2013-05-08 00:00:00"  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
      Given a customer named "ITC" exists with id "200" with admin "admin@itc.com"
        And the customer with id "200" has an outlet named "ITC - Bangalore" with id "20" with manager "manager@itc.com"
      When I authenticate as the user "bill_auth_token" with the password "random string"
      And I send a GET request to "/api/managers/200"
      Then the response status should be "404"
      And the JSON response should be:
      """
      {"errors": ["Manager record not found"]}
      """
    
  Scenario: Customer Admin is not authorized to get manager: Customer Admin of one outlet tries to get manager details of another customer
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            | created_at             |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    | "2013-01-08 00:00:00"  |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  | "2013-02-08 00:00:00"  |
         |3         |Noushad    |admin@itc.com                  | password123 | noushad_auth_token    | customer_admin  | "2013-03-08 00:00:00"  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         | "2013-04-08 00:00:00"  |
         |101       |Donald     |manager@itc.com                | password123 | donald_auth_token     | manager         | "2013-05-08 00:00:00"  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
      Given a customer named "ITC" exists with id "200" with admin "admin@itc.com"
        And the customer with id "200" has an outlet named "ITC - Bangalore" with id "20" with manager "manager@itc.com"
      When I authenticate as the user "noushad_auth_token" with the password "random string"
      And I send a GET request to "/api/managers/100"
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors": ["Insufficient privileges"]}
      """
   
  Scenario Outline: User's role is not customer_admin
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            | created_at             |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    | "2013-01-08 00:00:00"  |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  | "2013-02-08 00:00:00"  |
         |3         |Noushad    |admin@itc.com                  | password123 | noushad_auth_token    | customer_admin  | "2013-03-08 00:00:00"  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         | "2013-04-08 00:00:00"  |
         |101       |Donald     |manager@itc.com                | password123 | donald_auth_token     | manager         | "2013-05-08 00:00:00"  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
      Given a customer named "ITC" exists with id "200" with admin "admin@itc.com"
        And the customer with id "200" has an outlet named "ITC - Bangalore" with id "20" with manager "manager@itc.com"
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "<role>"
        And his authentication token is "auth_token_1234"
      When I authenticate as the user "auth_token_1234" with the password "random string"
      And I send a GET request to "/api/managers/100"
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors": ["Insufficient privileges"]}
      """
      Examples:
      |role|
      |kanari_admin|
      |manager|
      |staff|
      |user|
  
   Scenario: User is not authenticated
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            | created_at             |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    | "2013-01-08 00:00:00"  |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  | "2013-02-08 00:00:00"  |
         |3         |Noushad    |admin@itc.com                  | password123 | noushad_auth_token    | customer_admin  | "2013-03-08 00:00:00"  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         | "2013-04-08 00:00:00"  |
         |101       |Donald     |manager@itc.com                | password123 | donald_auth_token     | manager         | "2013-05-08 00:00:00"  |
      Given a customer named "ITC" exists with id "200" with admin "admin@itc.com"
        And the customer with id "200" has an outlet named "ITC - Bangalore" with id "20" with manager "manager@itc.com"
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_1234" with the password "random string"
      And I send a GET request to "/api/managers/100"
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors" : ["Invalid login credentials"]}
      """
