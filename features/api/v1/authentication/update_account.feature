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
          "password": "kobe1234",
          "password_confirmation": "kobe1234",
          "date_of_birth": "06-05-1987",
          "gender": "Male",
          "location": "SF",
          "phone_number": "+91234",
          "current_password": "password123"
        }
      }
      """
      Then the response status should be "200"
      And the JSON response should have "auth_token"
      And the JSON response at "auth_token" should be a string
      And the JSON response at "user_role" should be "user"
      And the JSON response at "registration_complete" should be true
      And a user should be created with the following
        |first_name|Kobe|
        |last_name|Bryant|
        |email|user@gmail.com|
        |gender|Male|
        |date_of_birth|1987-05-06|
        |location|SF|
        |phone_number|+91234|

    Scenario: Successfully updates user account: Updation of account details except Password, should not require current password.
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
          "date_of_birth": "06-05-1987",
          "gender": "Male",
          "location": "SF",
          "phone_number": "+91234"
        }
      }
      """
      Then the response status should be "200"
      And the JSON response should have "auth_token"
      And the JSON response at "auth_token" should be a string
      And the JSON response at "user_role" should be "user"
      And the JSON response at "registration_complete" should be true
      And a user should be created with the following
        |first_name|Kobe|
        |last_name|Bryant|
        |email|user@gmail.com|
        |gender|Male|
        |date_of_birth|1987-05-06|
        |location|SF|
        |phone_number|+91234|

   Scenario: User should not be able to update his email.
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
        And his role is "user"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_123" with the password "random string"
      When I send a PUT request to "/api/users" with the following:
      """
      {
        "user" : {
          "email": "modifiedemail@gmail.com"
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      {"errors": ["You can't update your email"]}
      """
      And there should not be any user with email "modifiedemail@gmail.com"
      And a user should be present with the following
        |first_name|Adam|
        |last_name|Smith|
        |email|user@gmail.com|

   Scenario: Change Password : Updation of password should require password_confirmation and current password.
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
        And his role is "user"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_123" with the password "random string"
      When I send a PUT request to "/api/users" with the following:
      """
      {
        "user" : {
          "password": "changedpwd123",
          "password_confirmation": "changedpwd123",
          "current_password": "password123"
        }
      }
      """
      Then the response status should be "200"
      And the JSON response should have "auth_token"
      And the JSON response at "auth_token" should be a string
      And the JSON response at "user_role" should be "user"
      And the JSON response at "registration_complete" should be true
      And a user should be created with the following
        |first_name|Adam|
        |last_name|Smith|
        |email|user@gmail.com|


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
