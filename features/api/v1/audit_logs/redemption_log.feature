Feature: Redemption Audit Log

    Background:
      Given I send and accept JSON

    Scenario: Successful redeem of points should a Log entry
      Given the following users exist
         |id        |first_name |email                        |password    |authentication_token |role   |
         |101       |Donald     |123456@kanari.co             |password123 |donald_auth_token    |staff  |
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10"
        And the outlet has "1000" points in its rewards pool
        And outlet "Subway - Bangalore" has staffs
          |123456@kanari.co   |
      Given "Kenny Bross" is a user with email id "simpleuser@gmail.com" and password "password123" and user id "1000"
        And his role is "user"
        And he has "200" points
        And he is redeeming points for the first time
        And his last activity was on "2013-01-01 01:00:00"
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
      And the staff "123456@kanari.co" should have approved the redemption with id "1"
      And the user's last activity should be on "2013-01-01"
      And a log entry should be created in "Redemption Log" table with following:
        |user_id|1000|
        |user_first_name|Kenny|
        |user_last_name|Bross|
        |user_email|simpleuser@gmail.com|
        |customer_id|100|
        |outlet_id|10|
        |generated_by|123456@kanari.co|
        |outlet_name|Subway - Bangalore|
        |points|100|
        |outlet_points_before|1000|
        |outlet_points_after|900|
        |user_points_before|200|
        |user_points_after|100|
        |redemption_id|1|
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
      {"errors": ["Redemption request not found"]}
      """
