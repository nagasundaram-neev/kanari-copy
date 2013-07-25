Feature: Approve Redemption

    Background:
      Given I send and accept JSON

  Scenario: Successfully approves redemption
      Given the following users exist
         |id        |first_name |email                        |password    |authentication_token |role   |
         |101       |Donald     |staff.bangalore.1@subway.com |password123 |donald_auth_token    |staff  |
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10"
        And the outlet has "1000" points in its rewards pool
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
      Given "Kenny Bross" is a user with email id "simpleuser@gmail.com" and password "password123" and user id "1000"
        And his role is "user"
        And he has "200" points
        And he is redeeming points for the first time
        And his authentication token is "auth_token_123"
        And the following redemptions exist
          |id           |outlet_id    |   user_id       |   points   | approved |
          |1            |10           |   1000          |   100      |   false  |
          |2            |10           |   1000          |   100      |   false  |
          |3            |10           |   2000          |   300      |   false  |
      When I authenticate as the user "donald_auth_token" with the password "random string"
      And I send a PUT request to "/api/redemptions/1" with the following:
      """
      {
        "redemption" : {
          "approve" : true
        }
      }
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      null
      """
      And the outlet's rewards pool should have "900" points
      And the user should have "100" redeemed points
      And the user should have "100" points
      And the user should have "1" redeem count
      And the staff "staff.bangalore.1@subway.com" should have approved the redemption with id "1"

  Scenario: Successfully approves redemption: User's redeems count and redeemed points should increase
      Given the following users exist
         |id        |first_name |email                        |password    |authentication_token |role   |
         |101       |Donald     |staff.bangalore.1@subway.com |password123 |donald_auth_token    |staff  |
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10"
        And the outlet has "1000" points in its rewards pool
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
      Given "Kenny Bross" is a user with email id "simpleuser@gmail.com" and password "password123" and user id "1000"
        And his role is "user"
        And his authentication token is "auth_token_123"
        And he has "200" points
        And till now he has redeemed "1000" points in "5" different redemptions
        And the following redemptions exist
          |id           |outlet_id    |   user_id       |   points   | approved |
          |1            |10           |   1000          |   100      |   false  |
          |2            |10           |   1000          |   100      |   false  |
          |3            |10           |   2000          |   300      |   false  |
      When I authenticate as the user "donald_auth_token" with the password "random string"
      And I send a PUT request to "/api/redemptions/1" with the following:
      """
      {
        "redemption" : {
          "approve" : true
        }
      }
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      null
      """
      And the outlet's rewards pool should have "900" points
      And the user should have "1100" redeemed points
      And the user should have "100" points
      And the user should have "6" redeem count
      And the staff "staff.bangalore.1@subway.com" should have approved the redemption with id "1"

    Scenario: User has already redeemed reward points
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10"
        And the outlet has "1000" points in its rewards pool
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |101       |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
        And the following redemptions exist
          |id           |outlet_id    |   user_id       |   points   | approved |
          |1            |10           |   1000          |   100      |   true  |
          |2            |10           |   2000          |   300      |   false  |
      When I authenticate as the user "donald_auth_token" with the password "random string"
      And I send a PUT request to "/api/redemptions/1" with the following:
      """
      {
        "redemption" : {
          "approve" : true
        }
      }
      """
      Then the response status should be "404"
      And the JSON response should be:
      """
      { "errors" : ["Either user has already redeemed reward points or the request for redemption is not found."] }
      """

    Scenario: User doesn't have enough points
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |101       |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10"
        And the outlet has "1000" points in its rewards pool
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
      Given "Kenny Bross" is a user with email id "simpleuser@gmail.com" and password "password123" and user id "1000"
        And his role is "user"
        And he has "100" points
        And his authentication token is "auth_token_123"
        And the following redemptions exist
          |id           |outlet_id    |   user_id       |   points   | approved |
          |1            |10           |   1000          |   150      |   false  |
          |2            |10           |   1000          |   100      |   false  |
          |3            |10           |   2000          |   300      |   false  |
      When I authenticate as the user "donald_auth_token" with the password "random string"
      And I send a PUT request to "/api/redemptions/1" with the following:
      """
      {
        "redemption" : {
          "approve" : true
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      { "errors" : ["User doesn't have enough points."] }
      """

    Scenario: Outlet doesn't have enough reward points
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |101       |Donald     |staff.bangalore.1@subway.com   | password123 | donald_auth_token     | staff           |
        And the following redemptions exist
          |id           |outlet_id    |   user_id       |   points   | approved |
          |1            |10           |   1000          |   100      |   false  |
          |2            |10           |   2000          |   300      |   false  |
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10"
        And the outlet has "10" points in its rewards pool
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
      When I authenticate as the user "donald_auth_token" with the password "random string"
      And I send a PUT request to "/api/redemptions/1" with the following:
      """
      {
        "redemption" : {
          "approve" : true
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      { "errors" : ["Outlet doesn't have enough rewards points."] }
      """

    Scenario: User is not authorized, Staff of one outlet tries to redeem for another outlet
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |1000      |David      |anotheruser@gmail.com          | password123 | david_auth_token      | user            |
         |101       |Adam       |staff.bangalore.1@subway.com   | password123 | adam_auth_token       | staff           |
         |102       |Kenny      |staff.bangalore.2@subway.com   | password123 | kenny_auth_token      | staff           |
         |103       |Tom        |staff.bangalore.1@taj.com      | password123 | tom_auth_token        | staff           |

      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      Given a customer named "Taj" exists with id "200" with admin "admin@taj.com"
        And the customer with id "200" has an outlet named "Taj - Bangalore" with id "20" with manager "manager@taj.com"
        And outlet "Taj - Bangalore" has staffs
          |staff.bangalore.1@taj.com   |
        And the following redemptions exist
          |id           |outlet_id    |   user_id       |   points   | approved |
          |1            |10           |   1000          |   100      |   false  |
          |2            |20           |   2000          |   300      |   false  |
      When I authenticate as the user "tom_auth_token" with the password "random string"
      And I send a PUT request to "/api/redemptions/1" with the following:
      """
      {
        "redemption" : {
          "approve" : true
        }
      }
      """
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors": ["Insufficient privileges"]}
      """

    Scenario: User is not authorized, User's role is 'user'
      Given the following users exist
         |id        |first_name |email                          | password    | authentication_token  | role            |
         |1000      |David      |anotheruser@gmail.com          | password123 | david_auth_token      | user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And the following redemptions exist
          |id           |outlet_id    |   user_id       |   points   | approved |
          |1            |10           |   1000          |   100      |   false  |
          |2            |10           |   2000          |   300      |   false  |
      When I authenticate as the user "david_auth_token" with the password "random string"
      And I send a PUT request to "/api/redemptions/1" with the following:
      """
      {
        "redemption" : {
          "approve" : true
        }
      }
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
      And I send a PUT request to "/api/redemptions/1" with the following:
      """
      {
        "redemption" : {
          "approve" : true
        }
      }
      """
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors" : ["Invalid login credentials"]}
      """

