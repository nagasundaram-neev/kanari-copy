Feature: Lists Create Kanari Code log

    Background:
      Given I send and accept JSON

	Scenario: Kanari Admin successfully lists code generation logs
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
     Given the following transactions exist in "Code Generation Log" table
          |id  |outlet_id |outlet_name           |code     |bill_size   |customer_id |feedback_id  |generated_by      |created_at         |
		  |1   |10        |Subway - Bangalore    |12345    |4000.99     |1           |1            |staff.bangalore.1 |2013-07-08 00:00:00|
		  |2   |10        |Subway - Bangalore    |23456    |1000.99     |1           |2            |staff.bangalore.1 |2013-07-07 01:00:00|
		  |3   |10        |Subway - Bangalore    |34567    |2000.99     |1           |3            |staff.bangalore.2 |2013-07-06 02:00:00|
		  |4   |20        |Subway - Pune         |45678    |1000.99     |1           |4            |staff.pune.1      |2013-07-06 02:00:00|
		  |5   |30        |Taj    - Mumbai       |56789    |1200.99     |2           |5            |staff.taj.1       |2013-07-06 00:06:00|
      When I authenticate as the user "admin_auth_token" with the password "random string"
	  And I send a GET request to "/api/audit_logs" with the following:
	  """
	  outlet_id=10&type=code_generation&start_time='2013-07-06 00:00:00'&end_time='2013-07-10 02:00:00'
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
            "feedback_id": 1,
            "code": "12345",
            "bill_size": 4000.99,
            "tablet_id": "staff.bangalore.1",
            "created_at": "2013-07-08 00:00:00"
          },
          {
            "id": 2,
            "customer_id": 1,
            "outlet_id": 10,
            "outlet_name": "Subway - Bangalore",
            "feedback_id": 2,
            "code": "23456",
            "bill_size": 1000.99,
            "tablet_id": "staff.bangalore.1",
            "created_at": "2013-07-07 01:00:00"
          },
          {
            "id": 3,
            "customer_id": 1,
            "outlet_id": 10,
            "outlet_name": "Subway - Bangalore",
            "feedback_id": 3,
            "code": "34567",
            "bill_size": 2000.99,
            "tablet_id": "staff.bangalore.2",
            "created_at": "2013-07-06 02:00:00"
          }
        ]
      }
      """

	Scenario: Kanari Admin successfully lists ALL code generation logs
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
     Given the following transactions exist in "Code Generation Log" table
          |id  |outlet_id |outlet_name           |code     |bill_size   |customer_id |feedback_id  |generated_by      |created_at         |
		  |1   |10        |Subway - Bangalore    |12345    |4000.99     |1           |1            |staff.bangalore.1 |2013-07-08 00:00:00|
		  |2   |10        |Subway - Bangalore    |23456    |1000.99     |1           |2            |staff.bangalore.1 |2013-07-07 01:00:00|
		  |3   |10        |Subway - Bangalore    |34567    |2000.99     |1           |3            |staff.bangalore.2 |2013-07-06 02:00:00|
		  |4   |20        |Subway - Pune         |45678    |1000.99     |1           |4            |staff.pune.1      |2013-07-06 02:00:00|
		  |5   |30        |Taj    - Mumbai       |56789    |1200.99     |2           |5            |staff.taj.1       |2013-07-06 00:06:00|
		  |6   |10        |Subway - Bangalore    |67890    |6000.99     |1           |6            |staff.bangalore.2 |2013-07-01 02:00:00|
      When I authenticate as the user "admin_auth_token" with the password "random string"
	  And I send a GET request to "/api/audit_logs" with the following:
	  """
	  outlet_id=10&type=code_generation
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
            "feedback_id": 1,
            "code": "12345",
            "bill_size": 4000.99,
            "tablet_id": "staff.bangalore.1",
            "created_at": "2013-07-08 00:00:00"
          },
          {
            "id": 2,
            "customer_id": 1,
            "outlet_id": 10,
            "outlet_name": "Subway - Bangalore",
            "feedback_id": 2,
            "code": "23456",
            "bill_size": 1000.99,
            "tablet_id": "staff.bangalore.1",
            "created_at": "2013-07-07 01:00:00"
          },
          {
            "id": 3,
            "customer_id": 1,
            "outlet_id": 10,
            "outlet_name": "Subway - Bangalore",
            "feedback_id": 3,
            "code": "34567",
            "bill_size": 2000.99,
            "tablet_id": "staff.bangalore.2",
            "created_at": "2013-07-06 02:00:00"
          },
          {
            "id": 6,
            "customer_id": 1,
            "outlet_id": 10,
            "outlet_name": "Subway - Bangalore",
            "feedback_id": 6,
            "code": "67890",
            "bill_size": 6000.99,
            "tablet_id": "staff.bangalore.2",
            "created_at": "2013-07-01 02:00:00"
          }
        ]
      }
      """


   Scenario: Kanari Admin successfully lists code generation logs: when there is no logs present for the outlet
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
     Given the following transactions exist in "Code Generation Log" table
          |id  |outlet_id |outlet_name           |code     |bill_size   |customer_id |feedback_id  |generated_by      |created_at         |
		  |1   |20        |Subway - Pune         |45678    |1000.99     |1           |4            |staff.pune.1      |2013-07-06 02:00:00|
		  |2   |30        |Taj    - Mumbai       |56789    |1200.99     |2           |5            |staff.taj.1       |2013-07-06 00:06:00|
      When I authenticate as the user "admin_auth_token" with the password "random string"
	  And I send a GET request to "/api/audit_logs" with the following:
	  """
	  outlet_id=10&type=code_generation&start_time='2013-07-06 00:00:00'&end_time='2013-07-10 02:00:00'
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
     Given the following transactions exist in "Code Generation Log" table
          |id  |outlet_id |outlet_name           |code     |bill_size   |customer_id |feedback_id  |generated_by      |created_at         |
		  |1   |10        |Subway - Bangalore    |12345    |4000.99     |1           |1            |staff.bangalore.1 |2013-07-08 00:00:00|
		  |2   |10        |Subway - Bangalore    |23456    |1000.99     |1           |2            |staff.bangalore.1 |2013-07-07 01:00:00|
		  |3   |10        |Subway - Bangalore    |34567    |2000.99     |1           |3            |staff.bangalore.2 |2013-07-06 02:00:00|
		  |4   |20        |Subway - Pune         |45678    |1000.99     |1           |4            |staff.pune.1      |2013-07-06 02:00:00|
      When I authenticate as the user "admin_auth_token" with the password "random string"
	  And I send a GET request to "/api/audit_logs" with the following:
	  """
	  outlet_id=30&type=code_generation&start_time='2013-07-06 00:00:00'&end_time='2013-07-10 02:00:00'
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
     Given the following transactions exist in "Code Generation Log" table
          |id  |outlet_id |outlet_name           |code     |bill_size   |customer_id |feedback_id  |generated_by      |created_at         |
		  |1   |10        |Subway - Bangalore    |12345    |4000.99     |1           |1            |staff.bangalore.1 |2013-07-08 00:00:00|
		  |2   |10        |Subway - Bangalore    |23456    |1000.99     |1           |2            |staff.bangalore.1 |2013-07-07 01:00:00|
		  |3   |10        |Subway - Bangalore    |34567    |2000.99     |1           |3            |staff.bangalore.2 |2013-07-06 02:00:00|
		  |4   |20        |Subway - Pune         |45678    |1000.99     |1           |4            |staff.pune.1      |2013-07-06 02:00:00|
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
     Given the following transactions exist in "Code Generation Log" table
          |id  |outlet_id |outlet_name           |code     |bill_size   |customer_id |feedback_id  |generated_by      |created_at         |
		  |1   |10        |Subway - Bangalore    |12345    |4000.99     |1           |1            |staff.bangalore.1 |2013-07-08 00:00:00|
		  |2   |10        |Subway - Bangalore    |23456    |1000.99     |1           |2            |staff.bangalore.1 |2013-07-07 01:00:00|
		  |3   |10        |Subway - Bangalore    |34567    |2000.99     |1           |3            |staff.bangalore.2 |2013-07-06 02:00:00|
		  |4   |20        |Subway - Pune         |45678    |1000.99     |1           |4            |staff.pune.1      |2013-07-06 02:00:00|
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
	  outlet_id=10&type=invalid&start_time='2013-07-06 00:00:00'&end_time='2013-07-10 02:00:00'
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
	  outlet_id=10&type=invalid&start_time='2013-07-06 00:00:00'&end_time='2013-07-10 02:00:00'
	  """
      Then the response status should be "401"
      And the JSON response should be:
      """
      { "errors" : ["Invalid login credentials"] }
      """
