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
        And outlet "Subway - Pune" is disabled
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
         "outlets": [
           {
            "id" : 1,
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
          },
          {
            "id" : 2,
            "name": "Subway - Pune",
            "address": null,
            "disabled": true,
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
          },
          {
            "id" : 3,
            "name": "NBC - Cochin",
            "address": null,
            "disabled": false,
            "email": null,
            "has_delivery": null,
            "has_outdoor_seating": null,
            "latitude": null,
            "longitude": null,
            "manager": {
              "email": "manager.cochin@nbc.com",
              "first_name": "Alex",
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
          },
          {
            "id" : 4,
            "name": "NBC - Bangalore",
            "address": null,
            "disabled": false,
            "email": null,
            "has_delivery": null,
            "has_outdoor_seating": null,
            "latitude": null,
            "longitude": null,
            "manager": {
              "email": "manager.bangalore@nbc.com",
              "first_name": "Paul",
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
        And outlet "Subway - Pune" is disabled
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
         "outlets": [
           {
            "id" : 1,
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
            "name": "Subway - Bangalore",
            "open_hours": null,
            "phone_number": null,
            "serves_alcohol": null,
            "website_url": null,
            "cuisine_types": [],
            "outlet_types": [],
            "redeemable_points": 0,
            "points_pending_redemption": 0
          },
          {
            "id" : 2,
            "address": null,
            "disabled": true,
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
            "name": "Subway - Pune",
            "open_hours": null,
            "phone_number": null,
            "serves_alcohol": null,
            "website_url": null,
            "cuisine_types": [],
            "outlet_types": [],
            "redeemable_points": 0,
            "points_pending_redemption": 0
           }
         ]
       }
      """
      When I authenticate as the user "noushad_auth_token" with the password "random string"
      And I send a GET request to "/api/outlets"
      Then the response status should be "200"
      And the JSON response should be:
      """
       {
         "outlets": [
           {
            "id" : 1,
            "address": null,
            "disabled": false,
            "email": null,
            "has_delivery": null,
            "has_outdoor_seating": null,
            "latitude": null,
            "longitude": null,
            "manager": {
              "email": "manager.cochin@nbc.com",
              "first_name": "Alex",
              "last_name": null,
              "phone_number": null
            },
            "name": "NBC - Cochin",
            "open_hours": null,
            "phone_number": null,
            "serves_alcohol": null,
            "website_url": null,
            "cuisine_types": [],
            "outlet_types": [],
            "redeemable_points": 0,
            "points_pending_redemption": 0
          },
          {
            "id" : 2,
            "address": null,
            "disabled": false,
            "email": null,
            "has_delivery": null,
            "has_outdoor_seating": null,
            "latitude": null,
            "longitude": null,
            "manager": {
              "email": "manager.bangalore@nbc.com",
              "first_name": "Paul",
              "last_name": null,
              "phone_number": null
            },
            "name": "NBC - Bangalore",
            "open_hours": null,
            "phone_number": null,
            "serves_alcohol": null,
            "website_url": null,
            "cuisine_types": [],
            "outlet_types": [],
            "redeemable_points": 0,
            "points_pending_redemption": 0
           }
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
        And outlet "Subway - Pune" is disabled
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
         "outlets": [
           {
            "id" : 1,
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
            "name": "Subway - Bangalore",
            "open_hours": null,
            "phone_number": null,
            "serves_alcohol": null,
            "website_url": null,
            "cuisine_types": [],
            "outlet_types": [],
            "redeemable_points": 0,
            "points_pending_redemption": 0
           }
         ]
       }
      """
      When I authenticate as the user "alex_auth_token" with the password "random string"
      And I send a GET request to "/api/outlets"
      Then the response status should be "200"
      And the JSON response should be:
      """
       {
         "outlets": [
           {
            "id" : 1,
            "address": null,
            "disabled": false,
            "email": null,
            "has_delivery": null,
            "has_outdoor_seating": null,
            "latitude": null,
            "longitude": null,
            "manager": {
              "email": "manager.cochin@nbc.com",
              "first_name": "Alex",
              "last_name": null,
              "phone_number": null
            },
            "name": "NBC - Cochin",
            "open_hours": null,
            "phone_number": null,
            "serves_alcohol": null,
            "website_url": null,
            "cuisine_types": [],
            "outlet_types": [],
            "redeemable_points": 0,
            "points_pending_redemption": 0
           }
         ]
       }
      """
      When I authenticate as the user "paul_auth_token" with the password "random string"
      And I send a GET request to "/api/outlets"
      Then the response status should be "200"
      And the JSON response should be:
      """
       {
         "outlets": [
           {
            "id" : 2,
            "address": null,
            "disabled": false,
            "email": null,
            "has_delivery": null,
            "has_outdoor_seating": null,
            "latitude": null,
            "longitude": null,
            "manager": {
              "email": "manager.bangalore@nbc.com",
              "first_name": "Paul",
              "last_name": null,
              "phone_number": null
            },
            "name": "NBC - Bangalore",
            "open_hours": null,
            "phone_number": null,
            "serves_alcohol": null,
            "website_url": null,
            "cuisine_types": [],
            "outlet_types": [],
            "redeemable_points": 0,
            "points_pending_redemption": 0
           }
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
        |IronMan    |staff.cochin.1@nbc.com         | password123 | ironMan_auth_token    | staff           |
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
         "outlets": [
           {
            "address": null,
            "disabled": false,
            "name": "<outlet_name>",
            "email": null,
            "has_delivery": null,
            "has_outdoor_seating": null,
            "latitude": null,
            "longitude": null,
            "manager": {
              "email": "<manager_email>",
              "first_name": "<manager_name>",
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
         ]
       }
      """
      Examples:
        |staff_token_prefix |outlet_name        |manager_email              | manager_name  |
        |donald             |Subway - Bangalore |manager@subway.com         | George        |
        |mickey             |Subway - Bangalore |manager@subway.com         | George        |
        |pluto              |Subway - Pune      |manager@subway.com         | George        |
        |goofy              |Subway - Pune      |manager@subway.com         | George        |
        |cyclops            |NBC - Bangalore    |manager.bangalore@nbc.com  | Paul          |
        |hulk               |NBC - Bangalore    |manager.bangalore@nbc.com  | Paul          |
        |ironMan            |NBC - Cochin       |manager.cochin@nbc.com     | Alex          |
        |wolverine          |NBC - Cochin       |manager.cochin@nbc.com     | Alex          |

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
        And outlet "Subway - Pune" is disabled
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
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
         "outlets": [
           {
            "id" : 1,
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
            "redeemable_points": 0
          },
          {
            "id" : 3,
            "name": "NBC - Cochin",
            "address": null,
            "disabled": false,
            "email": null,
            "has_delivery": null,
            "has_outdoor_seating": null,
            "latitude": null,
            "longitude": null,
            "manager": {
              "email": "manager.cochin@nbc.com",
              "first_name": "Alex",
              "last_name": null,
              "phone_number": null
            },
            "open_hours": null,
            "phone_number": null,
            "serves_alcohol": null,
            "website_url": null,
            "cuisine_types": [],
            "outlet_types": [],
            "redeemable_points": 0
          },
          {
            "id" : 4,
            "name": "NBC - Bangalore",
            "address": null,
            "disabled": false,
            "email": null,
            "has_delivery": null,
            "has_outdoor_seating": null,
            "latitude": null,
            "longitude": null,
            "manager": {
              "email": "manager.bangalore@nbc.com",
              "first_name": "Paul",
              "last_name": null,
              "phone_number": null
            },
            "open_hours": null,
            "phone_number": null,
            "serves_alcohol": null,
            "website_url": null,
            "cuisine_types": [],
            "outlet_types": [],
            "redeemable_points": 0
           }
         ]
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
