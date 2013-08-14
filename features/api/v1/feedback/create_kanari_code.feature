Feature: Create Kanari Code

    Background:
      Given I send and accept JSON

    Scenario: Staff successfully creates a kanari code
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
        |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  |
        |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
        |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
        |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
        |Mike       |simpleuser@gmail.com           | password123 | user_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      Given a customer named "Noushad the Big Chef" exists with id "200" with admin "admin@nbc.com"
      When I authenticate as the user "donald_auth_token" with the password "random string"
      And I send a POST request to "/api/kanari_codes" with the following:
      """
      {
        "bill_amount" : 1000.99
      }
      """
      Then the response status should be "201"
      Given I keep the JSON response at "code" as "CODE"
      Then the contents of %{CODE} should be a 5 digit number

    Scenario Outline: Rounding off bill amount
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
        |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  |
        |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
        |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
        |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
        |Mike       |simpleuser@gmail.com           | password123 | user_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      Given a customer named "Noushad the Big Chef" exists with id "200" with admin "admin@nbc.com"
      When I authenticate as the user "donald_auth_token" with the password "random string"
      And I send a POST request to "/api/kanari_codes" with the following:
      """
      {
        "bill_amount" : <bill_amount>
      }
      """
      Then the response status should be "201"
      Given I keep the JSON response at "code" as "CODE"
      Then the contents of %{CODE} should be a 5 digit number
      And a new feedback entry should be created with <rounded_points> points
    Examples:
      |bill_amount|rounded_points|
      |100.99|10|
      |101.99|10|
      |105.99|10|
      |106.99|10|
      |109.99|10|

    Scenario: Manager successfully creates a kanari code
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
        |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  |
        |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
        |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
        |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
        |Mike       |simpleuser@gmail.com           | password123 | user_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      Given a customer named "Noushad the Big Chef" exists with id "200" with admin "admin@nbc.com"
      When I authenticate as the user "george_auth_token" with the password "random string"
      And I send a POST request to "/api/kanari_codes" with the following:
      """
      {
        "bill_amount" : 1000.99
      }
      """
      Then the response status should be "201"
      Given I keep the JSON response at "code" as "CODE"
      Then the contents of %{CODE} should be a 5 digit number

    Scenario Outline: Outlet id is sent as parameter
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
        |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  |
        |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
        |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
        |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
        |Mike       |simpleuser@gmail.com           | password123 | user_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      Given a customer named "Noushad the Big Chef" exists with id "200" with admin "admin@nbc.com"
      When I authenticate as the user "<token_prefix>_auth_token" with the password "random string"
      And I send a POST request to "/api/kanari_codes" with the following:
      """
      {
        "bill_amount" : 1000.99,
        "outlet_id" : 10
      }
      """
      Then the response status should be "201"
      Given I keep the JSON response at "code" as "CODE"
      Then the contents of %{CODE} should be a 5 digit number
      Examples:
        |token_prefix|
        |bill|
        |george|

    Scenario Outline: User cannot create kanari codes for the outlet
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
        |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  |
        |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
        |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
        |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
        |Mike       |simpleuser@gmail.com           | password123 | user_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      Given a customer named "Noushad the Big Chef" exists with id "200" with admin "admin@nbc.com"
      When I authenticate as the user "<token_prefix>_auth_token" with the password "random string"
      And I send a POST request to "/api/kanari_codes" with the following:
      """
      {
        "bill_amount" : 1000.99,
        "outlet_id" : 10
      }
      """
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors" : ["Insufficient privileges"]}
      """
      Examples:
        |token_prefix|
        |admin|
        |noushad|
        |user|

    Scenario: Outlet not found
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
        |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  |
        |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
        |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
        |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
        |Mike       |simpleuser@gmail.com           | password123 | user_auth_token       | user            |
      When I authenticate as the user "donald_auth_token" with the password "random string"
      And I send a POST request to "/api/kanari_codes" with the following:
      """
      {
        "bill_amount" : 1000
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      {"errors" : ["Outlet not found"]}
      """
