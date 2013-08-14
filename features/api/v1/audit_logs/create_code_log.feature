Feature: Kanari Code Generation Audit Log

    Background:
      Given I send and accept JSON

    Scenario: Successful creation of Kanari code should have a Log entry
     Given the following users exist
       |id  |first_name |email                          | password    | authentication_token  | role            |
       |1   |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
       |2   |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
       |3   |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  |
       |4   |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
       |5   |Donald     |100001@subway.com              | password123 | donald_auth_token     | staff           |
       |6   |Mickey     |100002@subway.com              | password123 | mickey_auth_token     | staff           |
       |7   |Mike       |simpleuser@gmail.com           | password123 | user_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "1000" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |100001@subway.com   |
          |100002@subway.com   |
      Given a customer named "Noushad the Big Chef" exists with id "200" with admin "admin@nbc.com"
      When I authenticate as the user "donald_auth_token" with the password "random string"
      And I send a POST request to "/api/kanari_codes" with the following:
      """
      {
        "bill_amount" : 1000.00
      }
      """
      Then the response status should be "201"
      Given I keep the JSON response at "code" as "CODE"
      Then the contents of %{CODE} should be a 5 digit number
      And a log entry should be created in "Code Generation Log" table with following:
        |customer_id|100|
        |outlet_id|1000|
        |outlet_name|Subway - Bangalore|
        |generated_by|5|
        |bill_size|1000.00|
      And the code in the log table should be %{CODE}

    Scenario Outline: Failed generation of kanari code, should NOT have any log entry
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
        "bill_amount" : 1000.00,
        "outlet_id" : 10
      }
      """
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors" : ["Insufficient privileges"]}
	  """
      And there should not be any log entry in "Code Generation Log" table with following:
        |customer_id|100|
        |outlet_id|1000|
        |outlet_name|Subway - Bangalore|
        |generated_by|5|
        |bill_size|1000.00|
      Examples:
        |token_prefix|
        |admin|
        |noushad|
        |user|
