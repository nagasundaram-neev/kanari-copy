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
        And the outlet has "1000" points in its rewards pool
        And the following redemptions exist
          |outlet_id|points |approved |
          |10       |100    |true     |
          |10       |10     |false    |
      When I authenticate as the user "admin_auth_token" with the password "random string"
      And I send a GET request to "/api/outlets/10"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "outlet" : {
        "name": "Subway - Bangalore",
        "customer_id": 100,
        "customer_name": "Subway",
        "address": null,
        "disabled": false,
        "email": null,
        "has_delivery": null,
        "has_outdoor_seating": null,
        "latitude": null,
        "longitude": null,
        "manager": {
          "email": "manager@subway.com",
          "first_name": "George",
          "last_name": null,
          "phone_number": null
        },
        "open_hours": null,
        "phone_number": null,
        "serves_alcohol": null,
        "website_url": null,
        "cuisine_types": [],
        "outlet_types": [],
        "redeemable_points": 990,
        "points_pending_redemption": 10

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
        "name": "Subway - Bangalore",
        "address": null,
        "disabled": false,
        "email": null,
        "has_delivery": null,
        "has_outdoor_seating": null,
        "latitude": null,
        "longitude": null,
        "manager": {
          "email": "manager@subway.com",
          "first_name": "George",
          "last_name": null,
          "phone_number": null
        },
        "open_hours": null,
        "phone_number": null,
        "serves_alcohol": null,
        "website_url": null,
        "cuisine_types": [],
        "outlet_types": [],
        "redeemable_points": 0,
        "points_pending_redemption": 0

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
        "name": "Subway - Bangalore",
        "address": null,
        "disabled": false,
        "email": null,
        "has_delivery": null,
        "has_outdoor_seating": null,
        "latitude": null,
        "longitude": null,
        "manager": {
          "email": "manager@subway.com",
          "first_name": "George",
          "last_name": null,
          "phone_number": null
        },
        "open_hours": null,
        "phone_number": null,
        "serves_alcohol": null,
        "website_url": null,
        "cuisine_types": [],
        "outlet_types": [],
        "redeemable_points": 0,
        "points_pending_redemption": 0

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
        "name": "Subway - Bangalore",
        "address": null,
        "disabled": false,
        "email": null,
        "has_delivery": null,
        "has_outdoor_seating": null,
        "latitude": null,
        "longitude": null,
        "manager": {
          "email": "manager@subway.com",
          "first_name": "George",
          "last_name": null,
          "phone_number": null
        },
        "open_hours": null,
        "phone_number": null,
        "serves_alcohol": null,
        "website_url": null,
        "cuisine_types": [],
        "outlet_types": [],
        "redeemable_points": 0,
        "points_pending_redemption": 0

        }
      }
      """
      Examples:
        |staff_token_prefix |outlet_name        |
        |donald             |Subway - Bangalore |
        |mickey             |Subway - Bangalore |

    Scenario: User's role is "user" and outlet has more redeemable points
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |points_available|
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |0     |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |0     |
        |George     |manager@subway.com             | password123 | george_auth_token     | manager         |0     |
        |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |0     |
        |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |0     |
        |Mike       |simpleuser@gmail.com           | password123 | user_auth_token       | user            |120   |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the outlet has "1000" points in its rewards pool
        And the following redemptions exist
          |outlet_id|points |approved |
          |10       |100    |true     |
          |10       |10     |false    |
      When I authenticate as the user "user_auth_token" with the password "random string"
      And I send a GET request to "/api/outlets/10"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "outlet" : {
        "name": "Subway - Bangalore",
        "address": null,
        "disabled": false,
        "email": null,
        "has_delivery": null,
        "has_outdoor_seating": null,
        "latitude": null,
        "longitude": null,
        "manager": {
          "email": "manager@subway.com",
          "first_name": "George",
          "last_name": null,
          "phone_number": null
        },
        "open_hours": null,
        "phone_number": null,
        "serves_alcohol": null,
        "website_url": null,
        "cuisine_types": [],
        "outlet_types": [],
        "redeemable_points": 120
        }
      }
      """

    Scenario: User's role is "user" and outlet has less redeemable points
      Given the following users exist
        |first_name |email                          | password    | authentication_token  | role            |points_available|
        |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |0     |
        |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |0     |
        |George     |manager@subway.com             | password123 | george_auth_token     | manager         |0     |
        |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |0     |
        |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |0     |
        |Mike       |simpleuser@gmail.com           | password123 | user_auth_token       | user            |300   |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the outlet has "200" points in its rewards pool
        And the following redemptions exist
          |outlet_id|points |approved |
          |10       |100    |true     |
          |10       |10     |false    |
      When I authenticate as the user "user_auth_token" with the password "random string"
      And I send a GET request to "/api/outlets/10"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "outlet" : {
        "name": "Subway - Bangalore",
        "address": null,
        "disabled": false,
        "email": null,
        "has_delivery": null,
        "has_outdoor_seating": null,
        "latitude": null,
        "longitude": null,
        "manager": {
          "email": "manager@subway.com",
          "first_name": "George",
          "last_name": null,
          "phone_number": null
        },
        "open_hours": null,
        "phone_number": null,
        "serves_alcohol": null,
        "website_url": null,
        "cuisine_types": [],
        "outlet_types": [],
        "redeemable_points": 190
        }
      }
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
