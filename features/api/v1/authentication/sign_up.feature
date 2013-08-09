Feature: Sign Up

    Background:
      Given I send and accept JSON

    Scenario: Successful sign up
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
      And the JSON response should have "auth_token"
      And the JSON response at "auth_token" should be a string
      And the JSON response at "user_role" should be "user"
      And the JSON response at "first_name" should be "Kobe"
      And the JSON response at "last_name" should be "Bryant"
      And the JSON response at "registration_complete" should be true
      Given I keep the JSON response at "auth_token" as "AUTH_TOKEN"
      Then the user with email "kobe@gmail.com" should have "%{AUTH_TOKEN}" as his authentication_token
      And a user should be created with the following
        |first_name|Kobe|
        |last_name|Bryant|
        |email|kobe@gmail.com|

    Scenario: Successful sign up with oauth provider when user doesn't exist
      Given A facebook user exists who has registered with Kanari facebook app
      When I send a POST request to /api/users to use oauth with the following:
      """
      {
        "user" : {
          "first_name": "Kobe",
          "last_name": "Bryant",
          "email": "kobe@gmail.com"
        },
        "oauth_provider": "facebook",
        "access_token": "access_token_123"
      }
      """
      Then the response status should be "201"
      And the JSON response should have "auth_token"
      And the JSON response at "auth_token" should be a string
      And the JSON response at "user_role" should be "user"
      And the JSON response at "first_name" should be "Kobe"
      And the JSON response at "last_name" should be "Bryant"
      And the JSON response at "registration_complete" should be true
      Given I keep the JSON response at "auth_token" as "AUTH_TOKEN"
      Then the user with email "kobe@gmail.com" should have "%{AUTH_TOKEN}" as his authentication_token
      And a user should be created with the following
        |first_name|Kobe|
        |last_name|Bryant|
        |email|kobe@gmail.com|
      And the user with email "kobe@gmail.com" should have the following social network accounts
        |provider|
        |facebook|

    Scenario: Successful sign up with oauth provider when user exists
      Given "Kobe Bryant" is a user with email id "kobe@gmail.com" and password "password123"
        And his role is "user"
        And A facebook user exists who has registered with Kanari facebook app
      When I send a POST request to /api/users to use oauth with the following:
      """
      {
        "user" : {
          "first_name": "Kobe",
          "last_name": "Bryant",
          "email": "kobe@gmail.com"
        },
        "oauth_provider" : "facebook",
        "access_token" : "access_token_123"
      }
      """
      Then the response status should be "201"
      And the JSON response should have "auth_token"
      And the JSON response at "auth_token" should be a string
      And the JSON response at "user_role" should be "user"
      And the JSON response at "first_name" should be "Kobe"
      And the JSON response at "last_name" should be "Bryant"
      And the JSON response at "registration_complete" should be true
      Given I keep the JSON response at "auth_token" as "AUTH_TOKEN"
      Then the user with email "kobe@gmail.com" should have "%{AUTH_TOKEN}" as his authentication_token
      And a user should be created with the following
        |first_name|Kobe|
        |last_name|Bryant|
        |email|kobe@gmail.com|
      And the user with email "kobe@gmail.com" should have the following social network accounts
        |provider|
        |facebook|

    Scenario: Oauth provider exists for the user
      Given "Kobe Bryant" is a user with email id "kobe@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
        And his role is "user"
        And A facebook user exists who has registered with Kanari facebook app
      When I send a POST request to /api/users to use oauth with the following:
      """
      {
        "user" : {
          "first_name": "Kobe",
          "last_name": "Bryant",
          "email": "kobe@gmail.com"
        },
        "oauth_provider" : "facebook",
        "access_token" : "access_token_123"
      }
      """
      Then the response status should be "201"
      When I send a POST request to /api/users to use oauth with the following:
      """
      {
        "user" : {
          "first_name": "Kobe",
          "last_name": "Bryant",
          "email": "kobe@gmail.com"
        },
        "oauth_provider" : "facebook",
        "access_token" : "access_token_1234"
      }
      """
      Then the response status should be "201"
      And the JSON response should have "auth_token"
        And the auth_token should be different from "auth_token_123"
      And the JSON response at "user_role" should be "user"
      And the JSON response at "first_name" should be "Kobe"
      And the JSON response at "last_name" should be "Bryant"
      And the JSON response at "registration_complete" should be true
      Given I keep the JSON response at "auth_token" as "AUTH_TOKEN"
      Then the user with email "kobe@gmail.com" should have "%{AUTH_TOKEN}" as his authentication_token

    Scenario: Oauth token is invalid
      When I send a POST request to /api/users to use oauth with the following:
      """
      {
        "user" : {
          "first_name": "Kobe",
          "last_name": "Bryant",
          "email": "kobe@gmail.com"
        },
        "oauth_provider": "facebook",
        "access_token": "invalid_access_token"
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
       { "errors" : ["Access token is invalid"] }
      """

    Scenario: Passwords do not match
      When I send a POST request to "/api/users" with the following:
      """
      {
        "user" : {
          "first_name": "Kobe",
          "last_name": "Bryant",
          "email": "kobe@gmail.com",
          "password": "kobe1234",
          "password_confirmation": "kobe12345"
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      {"errors" : ["Password confirmation doesn't match Password"]}
      """

    Scenario: Email is already taken
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
      When I send a POST request to "/api/users" with the following:
      """
      {
        "user" : {
          "first_name": "Kobe",
          "last_name": "Bryant",
          "email": "user@gmail.com",
          "password": "kobe1234",
          "password_confirmation": "kobe1234"
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      {"errors" : ["Email has already been taken"]}
      """
