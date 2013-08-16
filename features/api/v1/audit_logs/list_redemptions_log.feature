Feature: Lists Redemption log

    Background:
      Given I send and accept JSON

	Scenario: Kanari Admin successfully lists redemption logs
     Given the following users exist
       |id  |first_name |email                          |password    |authentication_token  |role            |
       |1   |Adam       |superadmin@kanari.co           |password123 |admin_auth_token      |kanari_admin    |
       |2   |Jack       |manager@subway.com             |password123 |jack_auth_token       |manager         |
       |3   |Robert     |staff.bangalore.1@subway.com   |password123 |robert_auth_token     |staff           |
       |4   |Markus     |staff.bangalore.2@subway.com   |password123 |markus_auth_token     |staff           |
       |5   |Jay        |user1@gmail.com                |password123 |jay_auth_token        |user            |
       |6   |Ram        |user2@gmail.com                |password123 |ram_auth_token        |user            |
       |7   |Sam        |user3@gmail.com                |password123 |sam_auth_token        |user            |
       |8   |Abe        |user4@gmail.com                |password123 |abe_auth_token        |user            |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
	    And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
		And outlet "Subway - Bangalore" was created on "2013-01-01 00:00:00"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
     Given the following transactions exist in "Redemption Log" table
          |id  |outlet_id |outlet_name        |generated_by|points |customer_id |redemption_id |user_first_name |user_last_name |user_email       |outlet_points_before  |outlet_points_after  |user_points_before     |user_points_after |created_at         |
          |1   |10        |Subway - Bangalore |staff.bangalore.1|400    |1           |1           |Ram             |Singh          |user2@gmail.com  |1000                  |1400                 |1000                   |1400              |2013-07-08 00:00:00|
          |2   |10        |Subway - Bangalore |staff.bangalore.1|100    |1           |2           |Sam             |Singh          |user3@gmail.com  |1400                  |1500                 |100                    |200              |2013-07-07 01:00:00|
          |3   |10        |Subway - Bangalore |staff.bangalore.2|200    |1           |3           |Jay             |Singh          |user1@gmail.com  |1500                  |1700                 |1000                   |1200              |2013-07-06 02:00:00|
          |4   |20        |Subway - Pune      |staff.pune.1     |100    |1           |4           |Ram             |Singh          |user2@gmail.com  |1000                  |1100                 |1400                   |1500              |2013-07-06 02:00:00|
          |5   |30        |Taj    - Mumbai    |staff.mumbai.1   |120    |2           |5           |Abe             |Singh          |user4@gmail.com  |1000                  |1120                 |1000                   |1120              |2013-07-06 00:06:00|
      When I authenticate as the user "admin_auth_token" with the password "random string"
       And I send a GET request to "/api/audit_logs" with the following:
      """
      outlet_id=10&type=redemption&start_time='2013-07-06 00:00:00'&end_time='2013-07-10 02:00:00'
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "audit_logs": [
          {
            "id": 1,
            "customer_id": 1,
            "outlet_id": 10,
            "outlet_name": "Subway - Bangalore",
            "redemption_id": 1,
            "tablet_id": "staff.bangalore.1",
            "points": 400,
            "user_first_name": "Ram",
            "user_last_name":  "Singh",
            "user_email": "user2@gmail.com",
            "outlet_points_before": 1000,
            "outlet_points_after":  1400,
            "user_points_before": 1000,
            "user_points_after":  1400,
            "created_at": "2013-07-08 00:00:00"
          },
          {
            "id": 2,
            "customer_id": 1,
            "outlet_id": 10,
            "outlet_name": "Subway - Bangalore",
            "redemption_id": 2,
            "tablet_id": "staff.bangalore.1",
            "points": 100,
            "user_first_name": "Sam",
            "user_last_name":  "Singh",
            "user_email": "user3@gmail.com",
            "outlet_points_before": 1400,
            "outlet_points_after":  1500,
            "user_points_before": 100,
            "user_points_after":  200,
            "created_at": "2013-07-07 01:00:00"
          },
          {
            "id": 3,
            "customer_id": 1,
            "outlet_id": 10,
            "outlet_name": "Subway - Bangalore",
            "redemption_id": 3,
            "tablet_id": "staff.bangalore.2",
            "points": 200,
            "user_first_name": "Jay",
            "user_last_name":  "Singh",
            "user_email": "user1@gmail.com",
            "outlet_points_before": 1500,
            "outlet_points_after":  1700,
            "user_points_before": 1000,
            "user_points_after":  1200,
            "created_at": "2013-07-06 02:00:00"
          }
        ]
      }
      """

  Scenario: Kanari Admin successfully lists ALL redemption logs
     Given the following users exist
       |id  |first_name |email                          |password    |authentication_token  |role            |
       |1   |Adam       |superadmin@kanari.co           |password123 |admin_auth_token      |kanari_admin    |
       |2   |Jack       |manager@subway.com             |password123 |jack_auth_token       |manager         |
       |3   |Robert     |staff.bangalore.1@subway.com   |password123 |robert_auth_token     |staff           |
       |4   |Markus     |staff.bangalore.2@subway.com   |password123 |markus_auth_token     |staff           |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
	    And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
		And outlet "Subway - Bangalore" was created on "2013-01-01 00:00:00"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
     Given the following transactions exist in "Redemption Log" table
          |id  |outlet_id |outlet_name        |generated_by|points |customer_id |redemption_id |user_first_name |user_last_name |user_email       |outlet_points_before  |outlet_points_after  |user_points_before     |user_points_after |created_at         |
          |1   |10        |Subway - Bangalore |staff.bangalore.1|400    |1           |1           |Ram             |Singh          |user2@gmail.com  |1000                  |1400                 |1000                   |1400              |2013-07-08 00:00:00|
          |2   |10        |Subway - Bangalore |staff.bangalore.1|100    |1           |2           |Sam             |Singh          |user3@gmail.com  |1400                  |1500                 |100                    |200              |2013-07-07 01:00:00|
          |3   |10        |Subway - Bangalore |staff.bangalore.2|200    |1           |3           |Jay             |Singh          |user1@gmail.com  |1500                  |1700                 |1000                   |1200              |2013-07-06 02:00:00|
          |4   |20        |Subway - Pune      |staff.pune.1     |100    |1           |4           |Ram             |Singh          |user2@gmail.com  |1000                  |1100                 |1400                   |1500              |2013-07-06 02:00:00|
          |5   |30        |Taj    - Mumbai    |staff.mumbai.1   |120    |2           |5           |Abe             |Singh          |user4@gmail.com  |1000                  |1120                 |1000                   |1120              |2013-07-06 00:06:00|
    When I authenticate as the user "admin_auth_token" with the password "random string"
	  And I send a GET request to "/api/audit_logs" with the following:
	  """
	  outlet_id=10&type=redemption
	  """
	  Then the response status should be "200"
    And the JSON response should be:
      """
      {
        "audit_logs": [
          {
            "id": 1,
            "customer_id": 1,
            "outlet_id": 10,
            "outlet_name": "Subway - Bangalore",
            "redemption_id": 1,
            "tablet_id": "staff.bangalore.1",
            "points": 400,
            "user_first_name": "Ram",
            "user_last_name":  "Singh",
            "user_email": "user2@gmail.com",
            "outlet_points_before": 1000,
            "outlet_points_after":  1400,
            "user_points_before": 1000,
            "user_points_after":  1400,
            "created_at": "2013-07-08 00:00:00"
          },
          {
            "id": 2,
            "customer_id": 1,
            "outlet_id": 10,
            "outlet_name": "Subway - Bangalore",
            "redemption_id": 2,
            "tablet_id": "staff.bangalore.1",
            "points": 100,
            "user_first_name": "Sam",
            "user_last_name":  "Singh",
            "user_email": "user3@gmail.com",
            "outlet_points_before": 1400,
            "outlet_points_after":  1500,
            "user_points_before": 100,
            "user_points_after":  200,
            "created_at": "2013-07-07 01:00:00"
          },
          {
            "id": 3,
            "customer_id": 1,
            "outlet_id": 10,
            "outlet_name": "Subway - Bangalore",
            "redemption_id": 3,
            "tablet_id": "staff.bangalore.2",
            "points": 200,
            "user_first_name": "Jay",
            "user_last_name":  "Singh",
            "user_email": "user1@gmail.com",
            "outlet_points_before": 1500,
            "outlet_points_after":  1700,
            "user_points_before": 1000,
            "user_points_after":  1200,
            "created_at": "2013-07-06 02:00:00"
          }
        ]
      }
      """

   Scenario: Kanari Admin successfully lists redemption logs: when there is no logs present for the outlet
     Given the following users exist
       |id  |first_name |email                          |password    |authentication_token  |role            |
       |1   |Adam       |superadmin@kanari.co           |password123 |admin_auth_token      |kanari_admin    |
       |2   |Jack       |manager@subway.com             |password123 |jack_auth_token       |manager         |
       |3   |Robert     |staff.bangalore.1@subway.com   |password123 |robert_auth_token     |staff           |
       |4   |Markus     |staff.bangalore.2@subway.com   |password123 |markus_auth_token     |staff           |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
	    And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
		And outlet "Subway - Bangalore" was created on "2013-01-01 00:00:00"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
     Given the following transactions exist in "Redemption Log" table
          |id  |outlet_id |outlet_name        |generated_by|points |customer_id |redemption_id |user_first_name |user_last_name |user_email       |outlet_points_before  |outlet_points_after  |user_points_before     |user_points_after |created_at         |
          |1   |20        |Subway - Pune      |staff.pune.1     |100    |1           |4           |Ram             |Singh          |user2@gmail.com  |1000                  |1100                 |1400                   |1500              |2013-07-06 02:00:00|
          |2   |30        |Taj    - Mumbai    |staff.mumbai.1   |120    |2           |5           |Abe             |Singh          |user4@gmail.com  |1000                  |1120                 |1000                   |1120              |2013-07-06 00:06:00|
      When I authenticate as the user "admin_auth_token" with the password "random string"
       And I send a GET request to "/api/audit_logs" with the following:
       """
       outlet_id=10&type=redemption&start_time='2013-07-06 00:00:00'&end_time='2013-07-10 02:00:00'
       """
       Then the response status should be "200"
       And the JSON response should be:
       """
       {
         "audit_logs": []
       }
       """

   Scenario: Outlet doesn't exist
     Given the following users exist
       |id  |first_name |email                          |password    |authentication_token  |role            |
       |1   |Adam       |superadmin@kanari.co           |password123 |admin_auth_token      |kanari_admin    |
       |2   |Jack       |manager@subway.com             |password123 |jack_auth_token       |manager         |
       |3   |Robert     |staff.bangalore.1@subway.com   |password123 |robert_auth_token     |staff           |
       |4   |Markus     |staff.bangalore.2@subway.com   |password123 |markus_auth_token     |staff           |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" was created on "2013-01-01 00:00:00"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
     Given the following transactions exist in "Redemption Log" table
          |id  |outlet_id |outlet_name        |generated_by|points |customer_id |redemption_id |user_first_name |user_last_name |user_email       |outlet_points_before  |outlet_points_after  |user_points_before     |user_points_after |created_at         |
          |1   |20        |Subway - Pune      |staff.pune.1     |100    |1           |4           |Ram             |Singh          |user2@gmail.com  |1000                  |1100                 |1400                   |1500              |2013-07-06 02:00:00|
          |2   |30        |Taj    - Mumbai    |staff.mumbai.1   |120    |2           |5           |Abe             |Singh          |user4@gmail.com  |1000                  |1120                 |1000                   |1120              |2013-07-06 00:06:00|
      When I authenticate as the user "admin_auth_token" with the password "random string"
       And I send a GET request to "/api/audit_logs" with the following:
       """
       outlet_id=50&type=code_generation&start_time='2013-07-06 00:00:00'&end_time='2013-07-10 02:00:00'
       """
       Then the response status should be "404"
       And the JSON response should be:
       """
       {"errors": ["Outlet not found"]}
       """

	Scenario: Type parameter not given
     Given the following users exist
       |id  |first_name |email                          |password    |authentication_token  |role            |
       |1   |Adam       |superadmin@kanari.co           |password123 |admin_auth_token      |kanari_admin    |
       |2   |Jack       |manager@subway.com             |password123 |jack_auth_token       |manager         |
       |3   |Robert     |staff.bangalore.1@subway.com   |password123 |robert_auth_token     |staff           |
       |4   |Markus     |staff.bangalore.2@subway.com   |password123 |markus_auth_token     |staff           |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" was created on "2013-01-01 00:00:00"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
     Given the following transactions exist in "Redemption Log" table
          |id  |outlet_id |outlet_name        |generated_by|points |customer_id |redemption_id |user_first_name |user_last_name |user_email       |outlet_points_before  |outlet_points_after  |user_points_before     |user_points_after |created_at         |
          |1   |10        |Subway - Bangalore |staff.bangalore.1|400    |1           |1           |Ram             |Singh          |user2@gmail.com  |1000                  |1400                 |1000                   |1400              |2013-07-08 00:00:00|
          |2   |10        |Subway - Bangalore |staff.bangalore.1|100    |1           |2           |Sam             |Singh          |user3@gmail.com  |1400                  |1500                 |100                    |200              |2013-07-07 01:00:00|
          |3   |10        |Subway - Bangalore |staff.bangalore.2|200    |1           |3           |Jay             |Singh          |user1@gmail.com  |1500                  |1700                 |1000                   |1200              |2013-07-06 02:00:00|
          |4   |20        |Subway - Pune      |staff.pune.1     |100    |1           |4           |Ram             |Singh          |user2@gmail.com  |1000                  |1100                 |1400                   |1500              |2013-07-06 02:00:00|
          |5   |30        |Taj    - Mumbai    |staff.mumbai.1   |120    |2           |5           |Abe             |Singh          |user4@gmail.com  |1000                  |1120                 |1000                   |1120              |2013-07-06 00:06:00|
     When I authenticate as the user "admin_auth_token" with the password "random string"
     And I send a GET request to "/api/audit_logs" with the following:
     """
     outlet_id=10&start_time='2013-07-06 00:00:00'&end_time='2013-07-10 02:00:00'
     """
     Then the response status should be "404"
     And the JSON response should be:
     """
     {"errors": ["Type missing"]}
     """

  Scenario: Type is invalid
     Given the following users exist
       |id  |first_name |email                          |password    |authentication_token  |role            |
       |1   |Adam       |superadmin@kanari.co           |password123 |admin_auth_token      |kanari_admin    |
       |2   |Jack       |manager@subway.com             |password123 |jack_auth_token       |manager         |
       |3   |Robert     |staff.bangalore.1@subway.com   |password123 |robert_auth_token     |staff           |
       |4   |Markus     |staff.bangalore.2@subway.com   |password123 |markus_auth_token     |staff           |
      Given a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" was created on "2013-01-01 00:00:00"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
     Given the following transactions exist in "Redemption Log" table
          |id  |outlet_id |outlet_name        |generated_by|points |customer_id |redemption_id |user_first_name |user_last_name |user_email       |outlet_points_before  |outlet_points_after  |user_points_before     |user_points_after |created_at         |
          |1   |10        |Subway - Bangalore |staff.bangalore.1|400    |1           |1           |Ram             |Singh          |user2@gmail.com  |1000                  |1400                 |1000                   |1400              |2013-07-08 00:00:00|
          |2   |10        |Subway - Bangalore |staff.bangalore.1|100    |1           |2           |Sam             |Singh          |user3@gmail.com  |1400                  |1500                 |100                    |200              |2013-07-07 01:00:00|
          |3   |10        |Subway - Bangalore |staff.bangalore.2|200    |1           |3           |Jay             |Singh          |user1@gmail.com  |1500                  |1700                 |1000                   |1200              |2013-07-06 02:00:00|
          |4   |20        |Subway - Pune      |staff.pune.1     |100    |1           |4           |Ram             |Singh          |user2@gmail.com  |1000                  |1100                 |1400                   |1500              |2013-07-06 02:00:00|
          |5   |30        |Taj    - Mumbai    |staff.mumbai.1   |120    |2           |5           |Abe             |Singh          |user4@gmail.com  |1000                  |1120                 |1000                   |1120              |2013-07-06 00:06:00|
      When I authenticate as the user "admin_auth_token" with the password "random string"
       And I send a GET request to "/api/audit_logs" with the following:
      """
      outlet_id=10&type=invalid&start_time='2013-07-06 00:00:00'&end_time='2013-07-10 02:00:00'
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      {"errors": ["Type invalid"]}
      """

  Scenario Outline: User is not authorized : User role is not Kanari Admin
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "<role>"
        And his authentication token is "random_auth_token"
      When I authenticate as the user "random_auth_token" with the password "random string"
	  And I send a GET request to "/api/audit_logs" with the following:
	  """
	  outlet_id=10&type=redemption&start_time='2013-07-06 00:00:00'&end_time='2013-07-10 02:00:00'
	  """
      Then the response status should be "403"
      And the JSON response should be:
      """
      { "errors" : ["Insufficient privileges"] }
      """
      Examples:
      |role|
      |customer_admin|
      |manager|
      |staff|
      |user|

  Scenario: User is not authenticated
     When I send a GET request to "/api/audit_logs" with the following:
     """
     outlet_id=10&type=redemption&start_time='2013-07-06 00:00:00'&end_time='2013-07-10 02:00:00'
     """
      Then the response status should be "401"
      And the JSON response should be:
      """
      { "errors" : ["Invalid login credentials"] }
      """
