Feature: Sign In

    Background:
      Given I send and accept JSON

    Scenario: Successful sign in using email and password
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
        And his role is "kanari_admin"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "user@gmail.com" with the password "password123"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "200"
      And the JSON response should have "auth_token"
        And the auth_token should be different from "auth_token_123"
      And the JSON response at "user_role" should be "kanari_admin"
      And the JSON response at "registration_complete" should be true
      And the JSON response at "first_name" should be "Adam"
      And the JSON response at "last_name" should be "Smith"
      And the JSON response at "sign_in_count" should be 1
      And the JSON response at "customer_id" should be null

    Scenario: Sign in count on second login
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
        And his role is "kanari_admin"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "user@gmail.com" with the password "password123"
      And I send a POST request to "/api/users/sign_in"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "200"
      And the JSON response should have "auth_token"
        And the auth_token should be different from "auth_token_123"
      And the JSON response at "sign_in_count" should be 2

    Scenario: Successful sign in using authentication token
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
        And his role is "kanari_admin"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_123" with the password "X"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "200"
      And the JSON response should have "auth_token"
        And the auth_token should be different from "auth_token_123"
      And the JSON response at "user_role" should be "kanari_admin"
      And the JSON response at "first_name" should be "Adam"
      And the JSON response at "last_name" should be "Smith"

    Scenario: customer_admin who has not created a customer account
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "customer_admin"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_123" with the password "X"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "200"
      And the JSON response should have "auth_token"
        And the auth_token should be different from "auth_token_123"
      And the JSON response at "user_role" should be "customer_admin"
      And the JSON response at "registration_complete" should be false
      And the JSON response at "customer_id" should be null
      And the JSON response at "can_create_new_outlet" should be false

    Scenario: customer_admin who has created a customer account
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "customer_admin"
        And his authentication token is "auth_token_123"
        And a customer named "Subway" exists with id "100" with admin "user@gmail.com"
      When I authenticate as the user "auth_token_123" with the password "X"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "200"
      And the JSON response should have "auth_token"
        And the auth_token should be different from "auth_token_123"
      And the JSON response at "user_role" should be "customer_admin"
      And the JSON response at "registration_complete" should be true
      And the JSON response at "customer_id" should be 100
      And the JSON response at "can_create_new_outlet" should be true

    Scenario: customer_admin who has created a customer account and outlet limit NOT reached
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "customer_admin"
        And his authentication token is "auth_token_123"
        And a customer named "Subway" exists with id "100" with admin "user@gmail.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore"
        And the maximum number of authorized outlets for customer with id "100" is "2"
      When I authenticate as the user "auth_token_123" with the password "X"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "200"
      And the JSON response should have "auth_token"
        And the auth_token should be different from "auth_token_123"
      And the JSON response at "user_role" should be "customer_admin"
      And the JSON response at "registration_complete" should be true
      And the JSON response at "customer_id" should be 100
      And the JSON response at "can_create_new_outlet" should be true

    Scenario: customer_admin who has created a customer account and outlet limit reached
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "customer_admin"
        And his authentication token is "auth_token_123"
        And a customer named "Subway" exists with id "100" with admin "user@gmail.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore"
        And the maximum number of authorized outlets for customer with id "100" is "1"
      When I authenticate as the user "auth_token_123" with the password "X"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "200"
      And the JSON response should have "auth_token"
        And the auth_token should be different from "auth_token_123"
      And the JSON response at "user_role" should be "customer_admin"
      And the JSON response at "registration_complete" should be true
      And the JSON response at "customer_id" should be 100
      And the JSON response at "can_create_new_outlet" should be false

    Scenario: customer_admin who has active outlets
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "customer_admin"
        And his authentication token is "auth_token_123"
        And a customer named "Subway" exists with id "100" with admin "user@gmail.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      When I authenticate as the user "auth_token_123" with the password "X"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "200"
      And the JSON response should have "auth_token"
        And the auth_token should be different from "auth_token_123"
      And the JSON response at "user_role" should be "customer_admin"
      And the JSON response at "registration_complete" should be true
      And the JSON response at "customer_id" should be 100

    Scenario: customer_admin who has NO active outlets
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "customer_admin"
        And his authentication token is "auth_token_123"
        And a customer named "Subway" exists with id "100" with admin "user@gmail.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And outlet "Subway - Bangalore" is disabled
      When I authenticate as the user "auth_token_123" with the password "X"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "200"
      And the JSON response should have "auth_token"
      And the auth_token should be different from "auth_token_123"
      And the JSON response at "user_role" should be "customer_admin"
      And the JSON response at "registration_complete" should be true
      And the JSON response at "customer_id" should be 100

    Scenario: Manager who has active outlets
      Given "Adam" is a user with email id "manager@subway.com" and password "password123"
        And his role is "manager"
        And his authentication token is "auth_token_123"
        And a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      When I authenticate as the user "auth_token_123" with the password "X"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "200"
      And the JSON response should have "auth_token"
      And the auth_token should be different from "auth_token_123"
      And the JSON response at "user_role" should be "manager"
      And the JSON response at "registration_complete" should be true
      And the JSON response at "customer_id" should be 100

    Scenario: Manager who has NO active outlets
      Given "Adam" is a user with email id "manager@subway.com" and password "password123"
        And his role is "manager"
        And his authentication token is "auth_token_123"
        And a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And outlet "Subway - Bangalore" is disabled
      When I authenticate as the user "auth_token_123" with the password "X"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "422"
      And the JSON response should be:
      """
      {
        "errors": ["Inactive User"]
      }
      """

    Scenario: Manager who has both active and inactive outlets
      Given "Adam" is a user with email id "manager@subway.com" and password "password123"
        And his role is "manager"
        And his authentication token is "auth_token_123"
        And a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And outlet "Subway - Bangalore" is disabled
        And the customer with id "100" has an outlet named "Subway - Pune" with manager "manager@subway.com"
        When I authenticate as the user "auth_token_123" with the password "X"
        And I send a POST request to "/api/users/sign_in"
      Then the response status should be "200"
      And the JSON response should have "auth_token"
      And the auth_token should be different from "auth_token_123"
      And the JSON response at "user_role" should be "manager"
      And the JSON response at "registration_complete" should be true
      And the JSON response at "customer_id" should be 100

  Scenario: Staff who has active outlets
      Given "Adam" is a user with email id "staff.bangalore.1@subway.com" and password "password123"
        And his role is "staff"
        And his authentication token is "auth_token_123"
        And a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
      When I authenticate as the user "auth_token_123" with the password "X"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "200"
      And the JSON response should have "auth_token"
      And the auth_token should be different from "auth_token_123"
      And the JSON response at "user_role" should be "staff"
      And the JSON response at "registration_complete" should be true
      And the JSON response at "customer_id" should be 100

  Scenario: Staff who has NO active outlets
      Given "Adam" is a user with email id "staff.bangalore.1@subway.com" and password "password123"
        And his role is "staff"
        And his authentication token is "auth_token_123"
        And a customer named "Subway" exists with id "100" with admin "admin@subway.com"
        And the customer with id "100" has an outlet named "Subway - Bangalore" with manager "manager@subway.com"
        And outlet "Subway - Bangalore" has staffs
          |staff.bangalore.1@subway.com   |
          |staff.bangalore.2@subway.com   |
        And outlet "Subway - Bangalore" is disabled
      When I authenticate as the user "auth_token_123" with the password "X"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "422"
      And the JSON response should be:
      """
      {
        "errors": ["Inactive User"]
      }
      """

    Scenario: User successful signs in using email and password
      Given "Adam Smith" is a user with email id "user@gmail.com" and password "password123"
        And his role is "user"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "user@gmail.com" with the password "password123"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "200"
      And the JSON response should have "auth_token"
        And the auth_token should be different from "auth_token_123"
      And the JSON response at "user_role" should be "user"
      And the JSON response at "registration_complete" should be true
      And the JSON response at "first_name" should be "Adam"
      And the JSON response at "last_name" should be "Smith"
      And the JSON response at "sign_in_count" should be 1
      And the JSON response at "customer_id" should be null

  Scenario: Invalid email
      Given No user is present with email "user@gmail.com"
      When I authenticate as the user "user@gmail.com" with the password "password123"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "401"
      And the JSON response should be:
      """
      {
        "errors": ["Invalid login credentials"]
      }
      """

    Scenario: Invalid password
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
      When I authenticate as the user "user@gmail.com" with the password "password1234"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "401"
      And the JSON response should be:
      """
      {
        "errors" : ["Invalid login credentials"]
      }
      """

    Scenario: User should be able to login after confirmation only
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
      When I authenticate as the user "kobe@gmail.com" with the password "kobe1234"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "401"
      And the JSON response should be:
      """
      {
        "errors" : ["Invalid login credentials"]
      }
      """
      When "kobe@gmail.com" confirms the sign up
      When I authenticate as the user "kobe@gmail.com" with the password "kobe1234"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "200"
      And the JSON response should have "auth_token"
      And the JSON response at "user_role" should be "user"
      And the JSON response at "registration_complete" should be true
      And the JSON response at "first_name" should be "Kobe"
      And the JSON response at "last_name" should be "Bryant"
      And the JSON response at "sign_in_count" should be 1
      And the JSON response at "customer_id" should be null

    Scenario: Manager should be able to login after confirmation only
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "customer_admin"
        And his authentication token is "auth_token_123"
        And a customer named "Subway" exists with id "100" with admin "user@gmail.com"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a POST request to "/api/managers" with the following:
      """
      {
        "user" : {
          "email" : "manager@gmail.com",
          "first_name" : "John",
          "last_name" : "Doe",
          "phone_number" : "+9132222",
          "password" : "password123",
          "password_confirmation" : "password123"
        }
      }
      """
      Then the response status should be "201"
      Given the customer with id "100" has an outlet named "Subway - Bangalore" with manager "manager@gmail.com"
      And outlet "Subway - Bangalore" has staffs
        |staff.bangalore.1@subway.com   |
        |staff.bangalore.2@subway.com   |
      When I authenticate as the user "manager@gmail.com" with the password "password123"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "401"
      And the JSON response should be:
      """
      {
        "errors" : ["Invalid login credentials"]
      }
      """
      When "manager@gmail.com" confirms the sign up
      When I authenticate as the user "manager@gmail.com" with the password "password123"
      And I send a POST request to "/api/users/sign_in"
      Then the response status should be "200"
      And the JSON response should have "auth_token"
      And the JSON response at "user_role" should be "manager"
      And the JSON response at "registration_complete" should be true
      And the JSON response at "first_name" should be "John"
      And the JSON response at "last_name" should be "Doe"
      And the JSON response at "sign_in_count" should be 1
      And the JSON response at "customer_id" should be 100
