Feature: Request password recovery email

    Background:
      Given I send and accept JSON

    Scenario: Successfully request password recovery email
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
      And I send a POST request to "/api/users/password" with the following:
      """
      {
        "user" : {
          "email" : "user@gmail.com"
        }
      }
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      null
      """
      And "user@gmail.com" should receive an email with password reset link

    Scenario: Invalid email ID
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
      And I send a POST request to "/api/users/password" with the following:
      """
      {
        "user" : {
          "email" : "invalidemail@gmail.com"
        }
      }
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      null
      """
      And "invalidemail@gmail.com" should receive no email
