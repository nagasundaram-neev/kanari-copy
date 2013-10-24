Feature: Send Confirmation Email

    Background:
      Given I send and accept JSON

    Scenario: Successfully send a confirmation email by signing up
      When I send a POST request to "/api/users" with the following:
      """
      {
        "user" : {
          "first_name": "Kobe",
          "last_name": "Bryant",
          "email": "kobe@gmail.com",
          "password": "kobe1234",
          "password_confirmation": "kobe1234"
        }
      }
      """
      Then the response status should be "201"
      And the JSON response should be:
      """
      {
        "first_name": "Kobe",
        "last_name": "Bryant",
        "user_role": "user"
      }
      """
      And "kobe@gmail.com" should receive an email with sign up confirmation link

    Scenario: Generate confirmation link a second time
      When I send a POST request to "/api/users" with the following:
      """
      {
        "user" : {
          "first_name": "Kobe",
          "last_name": "Bryant",
          "email": "kobe@gmail.com",
          "password": "kobe1234",
          "password_confirmation": "kobe1234"
        }
      }
      """
      And "kobe@gmail.com" should receive an email with sign up confirmation link
      And I send a POST request to "/api/users/confirmation" with the following:
      """
      {
        "user" : {
          "email" : "kobe@gmail.com"
        }
      }
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      null
      """
      Then "kobe@gmail.com" should receive another confirmation email with the same token

