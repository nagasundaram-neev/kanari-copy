Feature: User Reachout

    Background:
      Given I send and accept JSON

    Scenario: Customer admin can successfully reach out to the feedback provider or registered user      
       Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "customer_admin"
        And his authentication token is "auth_token_123"
      Given a customer named "Subway" exists with id "100" with admin "user@gmail.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10"
      Given A feedback exists with the following attributes:
        |id           |10          |
        |code         |12345       |        
        |outlet_id    |10          |
        |completed    |true        |
        |user_id      |130         |        
        |user_status  |reach_out   |
      Given "Siva" is a user with email id "siva@gmail.com" and password "password123" and user id "130"
        And his role is "user"
      Given no emails have been sent        
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a PUT request to "/api/feedbacks/user_reachout/10"
      And feedback with id "10" completed should be "true"
      Then the response status should be "200"
      And feedback with id "10" user_status should be "pending"
      And "siva@gmail.com" should receive an email      


Scenario: Manager can successfully reach out to the feedback provider or registered user      
       Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "manager"
        And his authentication token is "auth_token_123"
      Given a customer named "Subway" exists with id "100" with admin "user@gmail.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "20" with manager "user@gmail.com"        
      Given A feedback exists with the following attributes:
        |id           |10          |
        |code         |12345       |        
        |outlet_id    |20          |
        |completed    |true        |
        |user_id      |130         |        
        |user_status  |reach_out   |
      Given "Siva" is a user with email id "siva@gmail.com" and password "password123" and user id "130"
        And his role is "user"
      Given no emails have been sent        
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a PUT request to "/api/feedbacks/user_reachout/10"
      And feedback with id "10" completed should be "true"
      Then the response status should be "200"
      And feedback with id "10" user_status should be "pending"
      And "siva@gmail.com" should receive an email with subject "The manager at Subway - Bangalore wants to contact you"

Scenario: Staff can not reach out to the feedback provider or registered user      
       Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "staff"
        And his authentication token is "auth_token_123"      
      Given A feedback exists with the following attributes:
        |id           |10          |
        |code         |12345       |        
        |outlet_id    |20          |
        |completed    |true        |
        |user_id      |130         |        
        |user_status  |reach_out   |
      Given "Siva" is a user with email id "siva@gmail.com" and password "password123" and user id "130"
        And his role is "user"
      Given no emails have been sent        
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a PUT request to "/api/feedbacks/user_reachout/10"
      And feedback with id "10" completed should be "true"
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors" : ["Insufficient privileges"]}
      """
      And "siva@gmail.com" should receive no email      


     Scenario: User is not authenticated
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_1234" with the password "random string"
	And I send a PUT request to "/api/feedbacks/user_reachout/10" 
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors" : ["Invalid login credentials"]}
      """