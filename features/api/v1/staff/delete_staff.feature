Feature: Delete Staff

    Background:
      Given I send and accept JSON

    Scenario: Customer Admin Successfully deletes a staff
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            | created_at             |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    | "2013-01-08 00:00:00"  |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  | "2013-02-08 00:00:00"  |
         |3         |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  | "2013-03-08 00:00:00"  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         | "2013-04-08 00:00:00"  |
         |101       |Donald     |123456@kanari.co               | password123 | donald_auth_token     | staff           | "2013-05-08 00:00:00"  |
         |102       |Robert     |654321@kanari.co               | password123 | robert_auth_token     | staff           | "2013-06-08 00:00:00"  |
         |103       |Joel       |989898@kanari.co               | password123 | joel_auth_token       | staff           | "2013-06-08 00:00:00"  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |123456@kanari.co   |
          |654321@kanari.co   |
      Given a customer named "ITC" exists with id "200" with admin "admin@itc.com"
        And the customer with id "200" has an outlet named "ITC - Bangalore" with id "20" with manager "manager@itc.com"
        And outlet "ITC - Bangalore" has staffs
          |989898@kanari.co   |
      When I authenticate as the user "bill_auth_token" with the password "random string"
      And I send a DELETE request to "/api/staffs/102"
      Then the response status should be "200"
      And the JSON response should be:
      """
      null
      """

    Scenario: Manager Successfully deletes a staff
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            | created_at             |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    | "2013-01-08 00:00:00"  |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  | "2013-02-08 00:00:00"  |
         |3         |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  | "2013-03-08 00:00:00"  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         | "2013-04-08 00:00:00"  |
         |101       |Donald     |123456@kanari.co               | password123 | donald_auth_token     | staff           | "2013-05-08 00:00:00"  |
         |102       |Robert     |654321@kanari.co               | password123 | robert_auth_token     | staff           | "2013-06-08 00:00:00"  |
         |103       |Joel       |989898@kanari.co               | password123 | joel_auth_token       | staff           | "2013-06-08 00:00:00"  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |123456@kanari.co   |
          |654321@kanari.co   |
      Given a customer named "ITC" exists with id "200" with admin "admin@itc.com"
        And the customer with id "200" has an outlet named "ITC - Bangalore" with id "20" with manager "manager@itc.com"
        And outlet "ITC - Bangalore" has staffs
          |989898@kanari.co   |
      When I authenticate as the user "george_auth_token" with the password "random string"
      And I send a DELETE request to "/api/staffs/102"
      Then the response status should be "200"
      And the JSON response should be:
      """
      null
      """

    Scenario: Staff not found
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            | created_at             |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    | "2013-01-08 00:00:00"  |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  | "2013-02-08 00:00:00"  |
         |3         |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  | "2013-03-08 00:00:00"  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         | "2013-04-08 00:00:00"  |
         |101       |Donald     |123456@kanari.co               | password123 | donald_auth_token     | staff           | "2013-05-08 00:00:00"  |
         |102       |Robert     |654321@kanari.co               | password123 | robert_auth_token     | staff           | "2013-06-08 00:00:00"  |
         |103       |Joel       |989898@kanari.co               | password123 | joel_auth_token       | staff           | "2013-06-08 00:00:00"  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |123456@kanari.co   |
          |654321@kanari.co   |
      Given a customer named "ITC" exists with id "200" with admin "admin@itc.com"
        And the customer with id "200" has an outlet named "ITC - Bangalore" with id "20" with manager "manager@itc.com"
        And outlet "ITC - Bangalore" has staffs
          |989898@kanari.co   |
      When I authenticate as the user "george_auth_token" with the password "random string"
      And I send a DELETE request to "/api/staffs/1000"
      Then the response status should be "404"
      And the JSON response should be:
      """
      {"errors": ["Staff record not found"]}
      """

   Scenario: Manager or Customer Admin is not authorized to delete staff: Manager of one outlet tries to delete staff of another outlet.
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            | created_at             |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    | "2013-01-08 00:00:00"  |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  | "2013-02-08 00:00:00"  |
         |3         |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  | "2013-03-08 00:00:00"  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         | "2013-04-08 00:00:00"  |
         |101       |Donald     |123456@kanari.co               | password123 | donald_auth_token     | staff           | "2013-05-08 00:00:00"  |
         |102       |Robert     |654321@kanari.co               | password123 | robert_auth_token     | staff           | "2013-06-08 00:00:00"  |
         |103       |Joel       |989898@kanari.co               | password123 | joel_auth_token       | staff           | "2013-06-08 00:00:00"  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |123456@kanari.co   |
          |654321@kanari.co   |
      Given a customer named "ITC" exists with id "200" with admin "admin@itc.com"
        And the customer with id "200" has an outlet named "ITC - Bangalore" with id "20" with manager "manager@itc.com"
        And outlet "ITC - Bangalore" has staffs
          |989898@kanari.co   |
      When I authenticate as the user "george_auth_token" with the password "random string"
      And I send a DELETE request to "/api/staffs/103"
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors": ["Insufficient privileges"]}
      """

   Scenario Outline: User's role is not customer_admin or manager
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            | created_at             |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    | "2013-01-08 00:00:00"  |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  | "2013-02-08 00:00:00"  |
         |3         |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  | "2013-03-08 00:00:00"  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         | "2013-04-08 00:00:00"  |
         |101       |Donald     |123456@kanari.co               | password123 | donald_auth_token     | staff           | "2013-05-08 00:00:00"  |
         |102       |Robert     |654321@kanari.co               | password123 | robert_auth_token     | staff           | "2013-06-08 00:00:00"  |
         |103       |Joel       |989898@kanari.co               | password123 | joel_auth_token       | staff           | "2013-06-08 00:00:00"  |
      Given a customer named "ITC" exists with id "200" with admin "admin@itc.com"
        And the customer with id "200" has an outlet named "ITC - Bangalore" with id "20" with manager "manager@itc.com"
        And outlet "ITC - Bangalore" has staffs
          |989898@kanari.co   |
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "<role>"
        And his authentication token is "auth_token_1234"
      When I authenticate as the user "auth_token_1234" with the password "random string"
      And I send a DELETE request to "/api/staffs/103"
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

   Scenario: User is not authenticated
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            | created_at             |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    | "2013-01-08 00:00:00"  |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  | "2013-02-08 00:00:00"  |
         |3         |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  | "2013-03-08 00:00:00"  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         | "2013-04-08 00:00:00"  |
         |101       |Donald     |123456@kanari.co               | password123 | donald_auth_token     | staff           | "2013-05-08 00:00:00"  |
         |102       |Robert     |654321@kanari.co               | password123 | robert_auth_token     | staff           | "2013-06-08 00:00:00"  |
         |103       |Joel       |989898@kanari.co               | password123 | joel_auth_token       | staff           | "2013-06-08 00:00:00"  |
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_1234" with the password "random string"
      And I send a DELETE request to "/api/staffs/103"
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors" : ["Invalid login credentials"]}
      """
