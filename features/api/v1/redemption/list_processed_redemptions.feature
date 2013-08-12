Feature: List Processed (Confirmed OR Expired) Redemptions

    Background:
      Given I send and accept JSON

    Scenario: Staff successfully lists processed redemptions
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
         |3         |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
         |101       |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
         |1000      |David      |anotheruser@gmail.com          | password123 | david_auth_token      | user            |
         |2000      |John       |someotheruser@gmail.com        | password123 | john_auth_token       | user            |
         |3000      |Mike       |simpleuser@gmail.com           | password123 | mike_auth_token       | user            |
         |10000     |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the following redemptions are requested before "100" minutes
          |id           |outlet_id    |   user_id       |   points   | approved |
          |1            |10           |   1000          |   100      |   false  |
          |2            |10           |   2000          |   300      |   false  |
          |3            |10           |   3000          |   200      |   true   |
          |4            |20           |   3000          |   200      |   false  |
          |5            |30           |   1000          |   100      |   false  |
        And the time limit for approving redemption is "30" minutes
      When I authenticate as the user "donald_auth_token" with the password "random string"
      And I send a GET request to "/api/redemptions" with the following:
      """
      outlet_id=10
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "redemptions": [
          {
            "id": 1,
            "approved_by": null,
            "outlet_id": 10,
            "points": 100,
            "user": {
              "date_of_birth": null,
              "email": "anotheruser@gmail.com",
              "first_name": "David",
              "gender": null,
              "last_name": null,
              "location": null,
              "phone_number": null,
              "redeems_count": null,
              "feedbacks_count": null,
              "last_activity_at": null,
              "points_available": 0,
              "points_redeemed": null
            }
          },
          {
            "id": 2,
            "approved_by": null,
            "outlet_id": 10,
            "points": 300,
            "user": {
              "date_of_birth": null,
              "email": "someotheruser@gmail.com",
              "first_name": "John",
              "gender": null,
              "last_name": null,
              "location": null,
              "phone_number": null,
              "redeems_count": null,
              "feedbacks_count": null,
              "last_activity_at": null,
              "points_available": 0,
              "points_redeemed": null
            }
          },
          {
            "id": 3,
            "approved_by": 10000,
            "outlet_id": 10,
            "points": 200,
            "user": {
              "date_of_birth": null,
              "email": "simpleuser@gmail.com",
              "first_name": "Mike",
              "gender": null,
              "last_name": null,
              "location": null,
              "phone_number": null,
              "redeems_count": null,
              "feedbacks_count": null,
              "last_activity_at": null,
              "points_available": 0,
              "points_redeemed": null
            }
          }
        ]
      }
      """

    Scenario: Manager OR Customer Admin successfully lists processed redemptions
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
         |3         |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
         |101       |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
         |1000      |David      |anotheruser@gmail.com          | password123 | david_auth_token      | user            |
         |2000      |John       |someotheruser@gmail.com        | password123 | john_auth_token       | user            |
         |3000      |Mike       |simpleuser@gmail.com           | password123 | mike_auth_token       | user            |
         |10000     |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the following redemptions are requested before "100" minutes
          |id           |outlet_id    |   user_id       |   points   | approved |
          |1            |10           |   1000          |   100      |   false  |
          |2            |10           |   2000          |   300      |   false  |
          |3            |10           |   3000          |   200      |   true   |
          |4            |20           |   3000          |   200      |   false  |
          |5            |30           |   1000          |   100      |   false  |
        And the time limit for approving redemption is "30" minutes
      When I authenticate as the user "george_auth_token" with the password "random string"
      And I send a GET request to "/api/redemptions" with the following:
      """
      outlet_id=10
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "redemptions": [
          {
            "id": 1,
            "approved_by": null,
            "outlet_id": 10,
            "points": 100,
            "user": {
              "date_of_birth": null,
              "email": "anotheruser@gmail.com",
              "first_name": "David",
              "gender": null,
              "last_name": null,
              "location": null,
              "phone_number": null,
              "redeems_count": null,
              "feedbacks_count": null,
              "last_activity_at": null,
              "points_available": 0,
              "points_redeemed": null
            }
          },
          {
            "id": 2,
            "approved_by": null,
            "outlet_id": 10,
            "points": 300,
            "user": {
              "date_of_birth": null,
              "email": "someotheruser@gmail.com",
              "first_name": "John",
              "gender": null,
              "last_name": null,
              "location": null,
              "phone_number": null,
              "redeems_count": null,
              "feedbacks_count": null,
              "last_activity_at": null,
              "points_available": 0,
              "points_redeemed": null
            }
          },
          {
            "id": 3,
            "approved_by": 10000,
            "outlet_id": 10,
            "points": 200,
            "user": {
              "date_of_birth": null,
              "email": "simpleuser@gmail.com",
              "first_name": "Mike",
              "gender": null,
              "last_name": null,
              "location": null,
              "phone_number": null,
              "redeems_count": null,
              "feedbacks_count": null,
              "last_activity_at": null,
              "points_available": 0,
              "points_redeemed": null
            }
          }
        ]
      }
      """

    Scenario: Outlet doesn't have any processed redemptions
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
         |3         |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
         |101       |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
         |102       |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
         |1000      |David      |anotheruser@gmail.com          | password123 | david_auth_token      | user            |
         |2000      |John       |someotheruser@gmail.com        | password123 | john_auth_token       | user            |
         |3000      |Mike       |simpleuser@gmail.com           | password123 | mike_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      When I authenticate as the user "donald_auth_token" with the password "random string"
      And I send a GET request to "/api/redemptions" with the following:
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "redemptions": []
      }
      """

    Scenario: User is not authenticated
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_1234" with the password "random string"
      And I send a GET request to "/api/redemptions" with the following:
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors" : ["Invalid login credentials"]}
      """

    Scenario: User is not authorized, User's role is 'user'
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
         |3         |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
         |101       |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
         |102       |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
         |1000      |David      |anotheruser@gmail.com          | password123 | david_auth_token      | user            |
         |2000      |John       |someotheruser@gmail.com        | password123 | john_auth_token       | user            |
         |3000      |Mike       |simpleuser@gmail.com           | password123 | mike_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the following redemptions exist
          |id           |outlet_id    |   user_id       |   points   | approved |
          |1            |10           |   1000          |   100      |   false  |
          |2            |10           |   2000          |   300      |   false  |
          |3            |10           |   3000          |   200      |   true   |
          |4            |20           |   3000          |   200      |   false  |
          |5            |30           |   1000          |   100      |   false  |
      When I authenticate as the user "david_auth_token" with the password "random string"
      And I send a GET request to "/api/redemptions" with the following:
      """
	  outlet_id=10
      """
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors": ["Insufficient privileges"]}
      """

    Scenario: User is not authorized, Staff or Manager or Customer Admin of one outlet tries to get list of processed redemptions for other outlet
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  |
         |3         |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         |
         |101       |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
         |102       |Mickey     |staff.bangalore.2@subway.com   | password123 | mickey_auth_token     | staff           |
         |103       |Scott      |staff.bangalore.1@nbc.com      | password123 | scott_auth_token      | staff           |
         |1000      |David      |anotheruser@gmail.com          | password123 | david_auth_token      | user            |
         |2000      |John       |someotheruser@gmail.com        | password123 | john_auth_token       | user            |
         |3000      |Mike       |simpleuser@gmail.com           | password123 | mike_auth_token       | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      Given a customer named "NBC" exists with id "200" with admin "admin@nbc.com"
        And the customer with id "200" has an outlet named "NBC - Bangalore" with id "20" with manager "manager@nbc.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@nbc.com   |
          |staff.bangalore.2@nbc.com   |
        And the following redemptions exist
          |id           |outlet_id    |   user_id       |   points   | approved |
          |1            |10           |   1000          |   100      |   false  |
          |2            |10           |   2000          |   300      |   false  |
          |3            |10           |   3000          |   200      |   true   |
          |4            |20           |   3000          |   200      |   false  |
          |5            |30           |   1000          |   100      |   false  |
      When I authenticate as the user "donald_auth_token" with the password "random string"
      And I send a GET request to "/api/redemptions" with the following:
      """
      outlet_id=20
      """
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors": ["Insufficient privileges"]}
      """

