Feature: Disable Outlet

    Background:
      Given I send and accept JSON

    Scenario: Kanari Admin successfully disables and enables outlet
     Given the following users exist
        |id |first_name | email                 |password    |authentication_token   |role           |
        |1  |Adam       | adam@kanari.co        |password123 |adam_auth_token        |kanari_admin   |
        |2  |Donald     | donald@customer.com   |password123 |donald_auth_token      |customer_admin |
     Given a customer named "Taj" exists with id "100" with admin "admin@taj.com"
       And the customer with id "100" has an outlet named "Taj - Bangalore" with manager "manager@taj.com"
       And the outlet's id is "20"
       And the outlet's email is "outlet@outlet.com"
      When I authenticate as the user "adam_auth_token" with the password "random string"
       And I send a PUT request to "/api/outlets/20/disable"
      Then the response status should be "200"
       And the JSON response should be:
       """
       null
	   """
      And the outlet "Taj - Bangalore" should be present under customer with id "100"
      And the outlet's email should still be "outlet@outlet.com"
      And the outlet should be disabled
      When I authenticate as the user "adam_auth_token" with the password "random string"
       And I send a PUT request to "/api/outlets/20/disable"
      Then the response status should be "200"
       And the JSON response should be:
       """
       null
	   """
      And the outlet "Taj - Bangalore" should be present under customer with id "100"
      And the outlet's email should still be "outlet@outlet.com"
      And the outlet should be enabled

  Scenario Outline: User is not authorized : User role is not Kanari Admin
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "<role>"
        And his authentication token is "random_auth_token"
     Given a customer named "Taj" exists with id "100" with admin "admin@taj.com"
       And the customer with id "100" has an outlet named "Taj - Bangalore" with manager "manager@taj.com"
       And the outlet's id is "20"
       And the outlet's email is "outlet@outlet.com"
      When I authenticate as the user "random_auth_token" with the password "random string"
       And I send a PUT request to "/api/outlets/20/disable"
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
      When I send a PUT request to "/api/outlets/20/disable"
      Then the response status should be "401"
      And the JSON response should be:
      """
      { "errors" : ["Invalid login credentials"] }
      """
