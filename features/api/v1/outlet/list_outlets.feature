Feature: List Outlets

    Background:
      Given I send and accept JSON

    Scenario: User's role is kanari_admin
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
        |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  |
        |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
        |Alex       |manager.cochin@nbc.com         | password123 | alex_auth_token       | manager         |
        |Paul       |manager.bangalore@nbc.com      | password123 | paul_auth_token       | manager         |
        |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
        |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
        |Pluto      |staff.pune.1@subway.com        | password123 | pluto_auth_token      | staff           |
        |Goofy      |staff.pune.2@subway.com        | password123 | goofy_auth_token      | staff           |
        |Cyclops    |staff.bangalore.1@nbc.com      | password123 | cyclops_auth_token    | staff           |
        |Hulk       |staff.bangalore.2@nbc.com      | password123 | hulk_auth_token       | staff           |
        |IronMan    |staff.cochin.1@nbc.com         | password123 | ironman_auth_token    | staff           |
        |Wolverine  |staff.cochin.2@nbc.com         | password123 | wolverine_auth_token  | staff           |
        |Mike       |simpleuser@gmail.com           | password123 | user_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the customer with id "100" has an outlet named "Subway - Pune" with manager "manager@subway.com"
        And outlet "Subway - Pune" has staffs
          |staff.pune.1@subway.com   |
          |staff.pune.2@subway.com   |
      Given a customer named "Noushad the Big Chef" exists with id "200" with admin "admin@nbc.com"
        And the customer with id "200" has an outlet named "NBC - Cochin" with manager "manager.cochin@nbc.com"
        And outlet "NBC - Cochin" has staffs
          |staff.cochin.1@nbc.com   |
          |staff.cochin.2@nbc.com   |
        And the customer with id "200" has an outlet named "NBC - Bangalore" with manager "manager.bangalore@nbc.com"
        And outlet "NBC - Bangalore" has staffs
          |staff.bangalore.1@nbc.com   |
          |staff.bangalore.2@nbc.com   |
      When I authenticate as the user "admin_auth_token" with the password "random string"
      And I send a GET request to "/api/outlets"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "outlets" : [
          {"id": 1, "name" : "Subway - Bangalore", "disabled" : false},
          {"id": 2, "name" : "Subway - Pune", "disabled" : false},
          {"id": 3, "name" : "NBC - Cochin", "disabled" : false},
          {"id": 4, "name" : "NBC - Bangalore", "disabled" : false}
        ]
      }
      """
    Scenario: User's role is customer_admin
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
        |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  |
        |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
        |Alex       |manager.cochin@nbc.com         | password123 | alex_auth_token       | manager         |
        |Paul       |manager.bangalore@nbc.com      | password123 | paul_auth_token       | manager         |
        |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
        |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
        |Pluto      |staff.pune.1@subway.com        | password123 | pluto_auth_token      | staff           |
        |Goofy      |staff.pune.2@subway.com        | password123 | goofy_auth_token      | staff           |
        |Cyclops    |staff.bangalore.1@nbc.com      | password123 | cyclops_auth_token    | staff           |
        |Hulk       |staff.bangalore.2@nbc.com      | password123 | hulk_auth_token       | staff           |
        |IronMan    |staff.cochin.1@nbc.com         | password123 | ironman_auth_token    | staff           |
        |Wolverine  |staff.cochin.2@nbc.com         | password123 | wolverine_auth_token  | staff           |
        |Mike       |simpleuser@gmail.com           | password123 | user_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the customer with id "100" has an outlet named "Subway - Pune" with manager "manager@subway.com"
        And outlet "Subway - Pune" has staffs
          |staff.pune.1@subway.com   |
          |staff.pune.2@subway.com   |
      Given a customer named "Noushad the Big Chef" exists with id "200" with admin "admin@nbc.com"
        And the customer with id "200" has an outlet named "NBC - Cochin" with manager "manager.cochin@nbc.com"
        And outlet "NBC - Cochin" has staffs
          |staff.cochin.1@nbc.com   |
          |staff.cochin.2@nbc.com   |
        And the customer with id "200" has an outlet named "NBC - Bangalore" with manager "manager.bangalore@nbc.com"
        And outlet "NBC - Bangalore" has staffs
          |staff.bangalore.1@nbc.com   |
          |staff.bangalore.2@nbc.com   |
      When I authenticate as the user "bill_auth_token" with the password "random string"
      And I send a GET request to "/api/outlets"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "outlets" : [
          {"id": 1, "name" : "Subway - Bangalore", "disabled" : false},
          {"id": 2, "name" : "Subway - Pune", "disabled" : false}
        ]
      }
      """
      When I authenticate as the user "noushad_auth_token" with the password "random string"
      And I send a GET request to "/api/outlets"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "outlets" : [
          {"id": 1, "name" : "NBC - Cochin", "disabled" : false},
          {"id": 2, "name" : "NBC - Bangalore", "disabled" : false}
        ]
      }
      """

    Scenario: User's role is manager
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
        |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  |
        |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
        |Alex       |manager.cochin@nbc.com         | password123 | alex_auth_token       | manager         |
        |Paul       |manager.bangalore@nbc.com      | password123 | paul_auth_token       | manager         |
        |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
        |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
        |Pluto      |staff.pune.1@subway.com        | password123 | pluto_auth_token      | staff           |
        |Goofy      |staff.pune.2@subway.com        | password123 | goofy_auth_token      | staff           |
        |Cyclops    |staff.bangalore.1@nbc.com      | password123 | cyclops_auth_token    | staff           |
        |Hulk       |staff.bangalore.2@nbc.com      | password123 | hulk_auth_token       | staff           |
        |IronMan    |staff.cochin.1@nbc.com         | password123 | ironman_auth_token    | staff           |
        |Wolverine  |staff.cochin.2@nbc.com         | password123 | wolverine_auth_token  | staff           |
        |Mike       |simpleuser@gmail.com           | password123 | user_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the customer with id "100" has an outlet named "Subway - Pune" with manager "manager@subway.com"
        And outlet "Subway - Pune" has staffs
          |staff.pune.1@subway.com   |
          |staff.pune.2@subway.com   |
      Given a customer named "Noushad the Big Chef" exists with id "200" with admin "admin@nbc.com"
        And the customer with id "200" has an outlet named "NBC - Cochin" with manager "manager.cochin@nbc.com"
        And outlet "NBC - Cochin" has staffs
          |staff.cochin.1@nbc.com   |
          |staff.cochin.2@nbc.com   |
        And the customer with id "200" has an outlet named "NBC - Bangalore" with manager "manager.bangalore@nbc.com"
        And outlet "NBC - Bangalore" has staffs
          |staff.bangalore.1@nbc.com   |
          |staff.bangalore.2@nbc.com   |
      When I authenticate as the user "george_auth_token" with the password "random string"
      And I send a GET request to "/api/outlets"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "outlets" : [
          {"id": 1, "name" : "Subway - Bangalore", "disabled" : false},
          {"id": 2, "name" : "Subway - Pune", "disabled" : false}
        ]
      }
      """
      When I authenticate as the user "alex_auth_token" with the password "random string"
      And I send a GET request to "/api/outlets"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "outlets" : [
          {"id": 1, "name" : "NBC - Cochin", "disabled" : false}
        ]
      }
      """
      When I authenticate as the user "paul_auth_token" with the password "random string"
      And I send a GET request to "/api/outlets"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "outlets" : [
          {"id": 2, "name" : "NBC - Bangalore", "disabled" : false}
        ]
      }
      """

    Scenario Outline: User's role is staff
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
        |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  |
        |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
        |Alex       |manager.cochin@nbc.com         | password123 | alex_auth_token       | manager         |
        |Paul       |manager.bangalore@nbc.com      | password123 | paul_auth_token       | manager         |
        |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
        |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
        |Pluto      |staff.pune.1@subway.com        | password123 | pluto_auth_token      | staff           |
        |Goofy      |staff.pune.2@subway.com        | password123 | goofy_auth_token      | staff           |
        |Cyclops    |staff.bangalore.1@nbc.com      | password123 | cyclops_auth_token    | staff           |
        |Hulk       |staff.bangalore.2@nbc.com      | password123 | hulk_auth_token       | staff           |
        |IronMan    |staff.cochin.1@nbc.com         | password123 | ironman_auth_token    | staff           |
        |Wolverine  |staff.cochin.2@nbc.com         | password123 | wolverine_auth_token  | staff           |
        |Mike       |simpleuser@gmail.com           | password123 | user_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the customer with id "100" has an outlet named "Subway - Pune" with manager "manager@subway.com"
        And outlet "Subway - Pune" has staffs
          |staff.pune.1@subway.com   |
          |staff.pune.2@subway.com   |
      Given a customer named "Noushad the Big Chef" exists with id "200" with admin "admin@nbc.com"
        And the customer with id "200" has an outlet named "NBC - Cochin" with manager "manager.cochin@nbc.com"
        And outlet "NBC - Cochin" has staffs
          |staff.cochin.1@nbc.com   |
          |staff.cochin.2@nbc.com   |
        And the customer with id "200" has an outlet named "NBC - Bangalore" with manager "manager.bangalore@nbc.com"
        And outlet "NBC - Bangalore" has staffs
          |staff.bangalore.1@nbc.com   |
          |staff.bangalore.2@nbc.com   |
      When I authenticate as the user "<staff_token_prefix>_auth_token" with the password "random string"
      And I send a GET request to "/api/outlets"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "outlets" : [
          {"id": 1, "name" : "<outlet_name>", "disabled" : false}
        ]
      }
      """
      Examples:
        |staff_token_prefix |outlet_name        |
        |donald             |Subway - Bangalore |
        |mickey             |Subway - Bangalore |
        |pluto              |Subway - Pune      |
        |goofy              |Subway - Pune      |
        |cyclops            |NBC - Bangalore    |
        |hulk               |NBC - Bangalore    |
        |ironMan            |NBC - Cochin       |
        |wolverine          |NBC - Cochin       |

    Scenario: User's role is "user"
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
        |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  |
        |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
        |Alex       |manager.cochin@nbc.com         | password123 | alex_auth_token       | manager         |
        |Paul       |manager.bangalore@nbc.com      | password123 | paul_auth_token       | manager         |
        |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
        |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
        |Pluto      |staff.pune.1@subway.com        | password123 | pluto_auth_token      | staff           |
        |Goofy      |staff.pune.2@subway.com        | password123 | goofy_auth_token      | staff           |
        |Cyclops    |staff.bangalore.1@nbc.com      | password123 | cyclops_auth_token    | staff           |
        |Hulk       |staff.bangalore.2@nbc.com      | password123 | hulk_auth_token       | staff           |
        |IronMan    |staff.cochin.1@nbc.com         | password123 | ironman_auth_token    | staff           |
        |Wolverine  |staff.cochin.2@nbc.com         | password123 | wolverine_auth_token  | staff           |
        |Mike       |simpleuser@gmail.com           | password123 | user_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the customer with id "100" has an outlet named "Subway - Pune" with manager "manager@subway.com"
        And outlet "Subway - Pune" has staffs
          |staff.pune.1@subway.com   |
          |staff.pune.2@subway.com   |
      Given a customer named "Noushad the Big Chef" exists with id "200" with admin "admin@nbc.com"
        And the customer with id "200" has an outlet named "NBC - Cochin" with manager "manager.cochin@nbc.com"
        And outlet "NBC - Cochin" has staffs
          |staff.cochin.1@nbc.com   |
          |staff.cochin.2@nbc.com   |
        And the customer with id "200" has an outlet named "NBC - Bangalore" with manager "manager.bangalore@nbc.com"
        And outlet "NBC - Bangalore" has staffs
          |staff.bangalore.1@nbc.com   |
          |staff.bangalore.2@nbc.com   |
      When I authenticate as the user "user_auth_token" with the password "random string"
      And I send a GET request to "/api/outlets"
      Then the response status should be "403"
      And the JSON response should be:
      """
      {
        "errors" : ["Insufficient privileges"]
      }
      """

    Scenario: User is not authenticated
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
        |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  |
        |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
        |Alex       |manager.cochin@nbc.com         | password123 | alex_auth_token       | manager         |
        |Paul       |manager.bangalore@nbc.com      | password123 | paul_auth_token       | manager         |
        |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
        |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
        |Pluto      |staff.pune.1@subway.com        | password123 | pluto_auth_token      | staff           |
        |Goofy      |staff.pune.2@subway.com        | password123 | goofy_auth_token      | staff           |
        |Cyclops    |staff.bangalore.1@nbc.com      | password123 | cyclops_auth_token    | staff           |
        |Hulk       |staff.bangalore.2@nbc.com      | password123 | hulk_auth_token       | staff           |
        |IronMan    |staff.cochin.1@nbc.com         | password123 | ironman_auth_token    | staff           |
        |Wolverine  |staff.cochin.2@nbc.com         | password123 | wolverine_auth_token  | staff           |
        |Mike       |simpleuser@gmail.com           | password123 | user_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the customer with id "100" has an outlet named "Subway - Pune" with manager "manager@subway.com"
        And outlet "Subway - Pune" has staffs
          |staff.pune.1@subway.com   |
          |staff.pune.2@subway.com   |
      Given a customer named "Noushad the Big Chef" exists with id "200" with admin "admin@nbc.com"
        And the customer with id "200" has an outlet named "NBC - Cochin" with manager "manager.cochin@nbc.com"
        And outlet "NBC - Cochin" has staffs
          |staff.cochin.1@nbc.com   |
          |staff.cochin.2@nbc.com   |
        And the customer with id "200" has an outlet named "NBC - Bangalore" with manager "manager.bangalore@nbc.com"
        And outlet "NBC - Bangalore" has staffs
          |staff.bangalore.1@nbc.com   |
          |staff.bangalore.2@nbc.com   |
      When I authenticate as the user "invalid_token" with the password "random string"
      And I send a GET request to "/api/outlets"
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors" : ["Invalid login credentials"]}
      """
