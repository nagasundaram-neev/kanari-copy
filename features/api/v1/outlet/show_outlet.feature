Feature: Show Outlet

    Background:
      Given I send and accept JSON

    Scenario: User's role is kanari_admin
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
        |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
        |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
        |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
        |Mike       |simpleuser@gmail.com           | password123 | user_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      When I authenticate as the user "admin_auth_token" with the password "random string"
      And I send a GET request to "/api/outlets/10"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "outlet" : {
          "id": 10,
          "name" : "Subway - Bangalore",
          "disabled" : false
        }
      }
      """

    Scenario: User's role is customer_admin
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
        |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
        |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
        |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
        |Mike       |simpleuser@gmail.com           | password123 | user_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      When I authenticate as the user "bill_auth_token" with the password "random string"
      And I send a GET request to "/api/outlets/10"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "outlet" : {
          "id": 10,
          "name" : "Subway - Bangalore",
          "disabled" : false
        }
      }
      """

    Scenario: User's role is manager
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
        |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
        |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
        |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
        |Mike       |simpleuser@gmail.com           | password123 | user_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      When I authenticate as the user "george_auth_token" with the password "random string"
      And I send a GET request to "/api/outlets/10"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "outlet" : {
          "id": 10,
          "name" : "Subway - Bangalore",
          "disabled" : false
        }
      }
      """

    Scenario Outline: User's role is staff
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
        |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
        |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
        |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
        |Mike       |simpleuser@gmail.com           | password123 | user_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      When I authenticate as the user "<staff_token_prefix>_auth_token" with the password "random string"
      And I send a GET request to "/api/outlets/10"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "outlet" : {
          "id": 10,
          "name" : "<outlet_name>",
          "disabled" : false
        }
      }
      """
      Examples:
        |staff_token_prefix |outlet_name        |
        |donald             |Subway - Bangalore |
        |mickey             |Subway - Bangalore |

    Scenario: User's role is "user"
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
        |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
        |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
        |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
        |Mike       |simpleuser@gmail.com           | password123 | user_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      When I authenticate as the user "user_auth_token" with the password "random string"
      And I send a GET request to "/api/outlets/10"
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors" : ["Insufficient privileges"]}
      """

    Scenario: User is not authenticated
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
        |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
        |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
        |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
        |Mike       |simpleuser@gmail.com           | password123 | user_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      When I authenticate as the user "invalid_auth_token" with the password "random string"
      And I send a GET request to "/api/outlets/10"
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors" : ["Invalid login credentials"]}
      """

    Scenario Outline: Outlet belongs to a different customer
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
        |Clinton    |admin@nbc.com                  | password123 | clinton_auth_token    | customer_admin  |
        |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
        |Bush       |manager@nbc.com                | password123 | bush_auth_token       | manager         |
        |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
        |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
        |Mike       |simpleuser@gmail.com           | password123 | user_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      When I authenticate as the user "<token_prefix>_auth_token" with the password "random string"
      And I send a GET request to "/api/outlets/10"
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors" : ["Insufficient privileges"]}
      """
      Examples:
      |token_prefix   |
      |clinton        |
      |bush           |
