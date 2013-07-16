Feature: List Tablets

    Background:
      Given I send and accept JSON

    Scenario: Manager successfully lists tablets for his outlet
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            | created_at             |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    | "2013-01-08 00:00:00"  |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  | "2013-02-08 00:00:00"  |
         |3         |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  | "2013-03-08 00:00:00"  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         | "2013-04-08 00:00:00"  |
         |101       |Donald     |123456@kanari.co               | password123 | donald_auth_token     | staff           | "2013-05-08 00:00:00"  |
         |102       |Robert     |654321@kanari.co               | password123 | robert_auth_token     | staff           | "2013-06-08 00:00:00"  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |123456@kanari.co   |
          |654321@kanari.co   |
      When I authenticate as the user "george_auth_token" with the password "random string"
      And I send a GET request to "/api/staffs"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "staffs": [
          {
            "id": 101,
            "tablet_id": "123456",
            "created_at": "2013-05-08 00:00:00",
            "date_of_birth": null,
            "email": "123456@kanari.co",
            "first_name": "Donald",
            "gender": null,
            "last_name": null,
            "location": null,
            "points_available": 0,
            "points_redeemed": null
          },
          {
            "id": 102,
            "tablet_id": "654321",
            "created_at": "2013-06-08 00:00:00",
            "date_of_birth": null,
            "email": "654321@kanari.co",
            "first_name": "Robert",
            "gender": null,
            "last_name": null,
            "location": null,
            "points_available": 0,
            "points_redeemed": null
          }
        ]
      }
	    """
  
    Scenario: User is not authorized, Customer Admin accesses tablet ids of another outlet
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            | created_at             |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    | "2013-01-08 00:00:00"  |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  | "2013-02-08 00:00:00"  |
         |3         |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  | "2013-03-08 00:00:00"  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         | "2013-04-08 00:00:00"  |
         |101       |Donald     |123456@kanari.co               | password123 | donald_auth_token     | staff           | "2013-05-08 00:00:00"  |
         |102       |Robert     |654321@kanari.co               | password123 | robert_auth_token     | staff           | "2013-06-08 00:00:00"  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |123456@kanari.co   |
          |654321@kanari.co   |
      When I authenticate as the user "noushad_auth_token" with the password "random string"
      And I send a GET request to "/api/staffs" with the following:
      """
      outlet_id=10
      """
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors": ["Insufficient privileges"]}
      """

    Scenario: User is not authorized, Customer Admin accesses tablet ids of another outlet
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            | created_at             |
         |1         |Adam       |superadmin@kanari.co           | password123 | admin_auth_token      | kanari_admin    | "2013-01-08 00:00:00"  |
         |2         |Bill       |admin@subway.com               | password123 | bill_auth_token       | customer_admin  | "2013-02-08 00:00:00"  |
         |3         |Noushad    |admin@nbc.com                  | password123 | noushad_auth_token    | customer_admin  | "2013-03-08 00:00:00"  |
         |100       |George     |manager@subway.com             | password123 | george_auth_token     | manager         | "2013-04-08 00:00:00"  |
         |101       |Donald     |123456@kanari.co               | password123 | donald_auth_token     | staff           | "2013-05-08 00:00:00"  |
         |102       |Robert     |654321@kanari.co               | password123 | robert_auth_token     | staff           | "2013-06-08 00:00:00"  |
         |1001      |David      |simpleuser@gmail.com           | password123 | david_auth_token      | user            | "2013-05-08 00:00:00"  |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |123456@kanari.co   |
          |654321@kanari.co   |
      When I authenticate as the user "david_auth_token" with the password "random string"
      And I send a GET request to "/api/staffs" with the following:
      """
      outlet_id=10
      """
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors": ["Insufficient privileges"]}
      """
  
   Scenario: User is not authenticated
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_1234" with the password "random string"
      And I send a GET request to "/api/staffs" with the following:
      """
      outlet_id=10
      """
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors" : ["Invalid login credentials"]}
      """
