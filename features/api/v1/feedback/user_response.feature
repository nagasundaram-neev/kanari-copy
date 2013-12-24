Feature: User Response

    Background:
      Given I send and accept JSON

    Scenario: Customer admin can contact the feedback provider or registered user
      Given "Siva" is a user with email id "siva@gmail.com" and password "password123" and user id "130"
        And his role is "user"
      Given "Adam" is a user with email id "user@gmail.com" and password "password12" and user id "20"
        And his role is "customer_admin"
      Given a customer named "Subway" exists with id "100"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10"
      Given A feedback exists with the following attributes:
        |id           |10          |
        |code         |12345       |
        |outlet_id    |10          |
        |completed    |true        |
        |user_id      |130         |
        |user_status  |pending     |
      Given no emails have been sent
      When feedback with id "10" user_status should be "pending"
      And I send a GET request to "/api/feedbacks/user_response/10?contacted_user_id=20&response=1&send_id=130"
      And feedback with id "10" user_id should be "130"
      And feedback with id "10" completed should be "true"
      Then the response status should be "200"
      And feedback with id "10" user_status should be "accepted"
      And "user@gmail.com" should receive an email with subject "Kanari: Your Reach Out request has been accepted"

Scenario: Manager cannot contact the feedback provider or registered user
       Given "Siva" is a user with email id "siva@gmail.com" and password "password123" and user id "130"
        And his role is "user"
       Given "Adam" is a user with email id "user@gmail.com" and password "password12" and user id "20"
        And his role is "customer_admin"
      Given a customer named "Subway" exists with id "100" with admin "user@gmail.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10"
      Given A feedback exists with the following attributes:
        |id           |10          |
        |code         |12345       |
        |outlet_id    |10          |
        |completed    |true        |
        |user_id      |130         |
        |user_status  |pending     |
      Given no emails have been sent
      When feedback with id "10" user_status should be "pending"
      And I send a GET request to "/api/feedbacks/user_response/10?contacted_user_id=20&response=0&send_id=130"
      And feedback with id "10" user_id should be "130"
      And feedback with id "10" completed should be "true"
      Then the response status should be "200"
      And feedback with id "10" user_status should be "rejected"
      And "user@gmail.com" should receive no email


Scenario: Should give error if trying to access incorrect feedback
       Given "Siva" is a user with email id "siva@gmail.com" and password "password123" and user id "130"
        And his role is "user"
       Given "Adam" is a user with email id "user@gmail.com" and password "password12" and user id "20"
        And his role is "customer_admin"
      Given a customer named "Subway" exists with id "100" with admin "user@gmail.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with id "10"
      Given A feedback exists with the following attributes:
        |id           |10          |
        |code         |12345       |
        |outlet_id    |10          |
        |completed    |true        |
        |user_id      |130         |
        |user_status  |pending     |
      Given no emails have been sent
      When feedback with id "10" user_status should be "pending"
      And I send a GET request to "/api/feedbacks/user_response/20?contacted_user_id=20&response=0&send_id=130"
      And feedback with id "10" user_id should be "130"
      And feedback with id "10" completed should be "true"
      Then the response status should be "404"
      And the JSON response should be:
      """
      {"errors" : ["Feedback not found."]}
      """
      And "user@gmail.com" should receive no email