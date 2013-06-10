Feature: Update account

    Background:
      Given I send and accept JSON

    Scenario: Successfully update user account
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
        And his role is "user"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_123" with the password "random string"
      When I send a PUT request to "/api/users" with the following:
      """
      {
        "user" : {
          "first_name": "Kobe",
          "last_name": "Bryant",
          "email": "kobe@gmail.com",
          "password": "kobe1234",
          "password_confirmation": "kobe1234",
          "date_of_birth": "06-05-1987",
          "gender": "Male",
          "location": "SF",
          "current_password": "password123"
        }
      }
      """
      Then the response status should be "200"
      And the JSON response should have "auth_token"
      And the JSON response at "auth_token" should be a string
      And the JSON response at "user_role" should be "user"
      And the JSON response at "registration_complete" should be true

    Scenario: User not authenticated
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
        And his role is "user"
        And his authentication token is "auth_token_1234"
      When I send a PUT request to "/api/users" with the following:
      """
      {
        "user" : {
          "first_name": "Kobe",
          "last_name": "Bryant",
          "email": "kobe@gmail.com",
          "password": "kobe1234",
          "password_confirmation": "kobe1234",
          "date_of_birth": "06-05-1987",
          "gender": "Male",
          "location": "SF",
          "current_password": "password123"
        }
      }
      """
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors" : ["Invalid login credentials"]}
      """

    Scenario: Passwords do not match
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
        And his role is "user"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_123" with the password "random string"
      When I send a PUT request to "/api/users" with the following:
      """
      {
        "user" : {
          "first_name": "Kobe",
          "last_name": "Bryant",
          "email": "kobe@gmail.com",
          "password": "kobe1234",
          "password_confirmation": "kobe12345",
          "date_of_birth": "06-05-1987",
          "gender": "Male",
          "location": "SF",
          "current_password": "password123"
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      {"errors" : ["Password confirmation doesn't match Password"]}
      """

    Scenario: Current password is invalid
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
        And his role is "user"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_123" with the password "random string"
      When I send a PUT request to "/api/users" with the following:
      """
      {
        "user" : {
          "first_name": "Kobe",
          "last_name": "Bryant",
          "email": "kobe@gmail.com",
          "password": "kobe1234",
          "password_confirmation": "kobe1234",
          "date_of_birth": "06-05-1987",
          "gender": "Male",
          "location": "SF",
          "current_password": "password1234"
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      {"errors" : ["Current password is invalid"]}
      """

    Scenario: Email is already taken
      Given "User" is a user with email id "user@gmail.com" and password "password123"
      Given "Adam Smith" is a user with email id "adam@gmail.com" and password "password123"
        And his role is "user"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_123" with the password "random string"
      When I send a PUT request to "/api/users" with the following:
      """
      {
        "user" : {
          "first_name": "Kobe",
          "last_name": "Bryant",
          "email": "user@gmail.com",
          "password": "kobe1234",
          "password_confirmation": "kobe1234",
          "date_of_birth": "06-05-1987",
          "gender": "Male",
          "location": "SF",
          "current_password": "password123"
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      {"errors" : ["Email has already been taken"]}
      """

    Scenario: Attempt to change role by sending it in the params
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
        And his role is "user"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_123" with the password "random string"
      When I send a PUT request to "/api/users" with the following:
      """
      {
        "user" : {
          "first_name": "Kobe",
          "last_name": "Bryant",
          "email": "kobe@gmail.com",
          "password": "kobe1234",
          "password_confirmation": "kobe1234",
          "date_of_birth": "06-05-1987",
          "gender": "Male",
          "location": "SF",
          "role": "customer_admin",
          "current_password": "password123"
        }
      }
      """
      Then the response status should be "200"
      And the JSON response at "user_role" should be "user"
