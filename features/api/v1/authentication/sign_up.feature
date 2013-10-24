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
      And the JSON response at "user_role" should be "user"
      And the JSON response at "first_name" should be "Kobe"
      And the JSON response at "last_name" should be "Bryant"
      And a user should be created with the following
        |first_name|Kobe|
        |last_name|Bryant|
        |email|kobe@gmail.com|
      And "kobe@gmail.com" should receive an email with sign up confirmation link

    Scenario: Successful sign up with oauth provider when user doesn't exist
      Given A facebook user exists who has registered with Kanari facebook app
      When I send a POST request to /api/users to use oauth with the following:
      """
      {
        "user" : {
          "first_name": "Kobe",
          "last_name": "Bryant",
          "email": "kobe@gmail.com",
          "gender": "Male",
          "date_of_birth": "1929-12-31"
        },
        "oauth_provider": "facebook",
        "access_token": "access_token_123"
      }
      """
      Then the response status should be "201"
      And the JSON response at "user_role" should be "user"
      And the JSON response at "first_name" should be "Kobe"
      And the JSON response at "last_name" should be "Bryant"
      And a user should be created with the following
        |first_name|Kobe|
        |last_name|Bryant|
        |email|kobe@gmail.com|
        |gender|Male|
        |date_of_birth|1929-12-31|
      And the user with email "kobe@gmail.com" should have the following social network accounts
        |provider|
        |facebook|
      And "kobe@gmail.com" should receive an email with sign up confirmation link

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
      And the JSON response at "user_role" should be "user"
      And the JSON response at "first_name" should be "Kobe"
      And the JSON response at "last_name" should be "Bryant"
      And a user should be created with the following
        |first_name|Kobe|
        |last_name|Bryant|
        |email|kobe@gmail.com|
      And the user with email "kobe@gmail.com" should have the following social network accounts
        |provider|
        |facebook|
      And "kobe@gmail.com" should receive an email with sign up confirmation link

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
      And the JSON response at "user_role" should be "user"
      And the JSON response at "first_name" should be "Kobe"
      And the JSON response at "last_name" should be "Bryant"
      And "kobe@gmail.com" should receive an email with sign up confirmation link

    Scenario: Oauth provider exists for the user ( edge case when another user exists )
      Given "Axl Rose" is a user with email id "axl@gmail.com" and password "password123"
        And his authentication token is "auth_token_1234"
        And his role is "user"
        And A facebook user exists who has registered with Kanari facebook app
      And I send a POST request to /api/users to use oauth with the following:
      """
      {
        "user" : {
          "first_name": "Axl",
          "last_name": "Rose",
          "email": "axl@gmail.com"
        },
        "oauth_provider" : "facebook",
        "access_token" : "valid_token"
      }
      """
      Given I will remember the access_token of "axl@gmail.com" for "facebook" provider
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
      And the JSON response at "user_role" should be "user"
      And the JSON response at "first_name" should be "Kobe"
      And the JSON response at "last_name" should be "Bryant"
      Then access_token of "axl@gmail.com" for "facebook" provider should not have changed
      And "kobe@gmail.com" should receive an email with sign up confirmation link

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
