Feature: Create invitation

    Background:
      Given I send and accept JSON

    Scenario: Successfully create an invitation by sending auth_token as a parameter
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
      And I send a POST request to "/api/users/invitation" with the following:
      """
      {
        "user" : {
          "email" : "newuser@gmail.com"
        },
        "auth_token" : "auth_token_123"
      }
      """
      Then the response status should be "201"
      And the JSON response should have "invitation_token"
      Given I keep the JSON response at "invitation_token" as "TOKEN"
      Then %{TOKEN} should belong to the new inactive user that was created
      And "newuser@gmail.com" should receive no email

    Scenario: Successfully create an invitation by sending auth_token in the HTTP auth header
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_123" with the password "X"
      And I send a POST request to "/api/users/invitation" with the following:
      """
      {
        "user" : {
          "email" : "newuser@gmail.com"
        }
      }
      """
      Then the response status should be "201"
      And the JSON response should have "invitation_token"
      And the new user should have role "customer_admin"
      Given I keep the JSON response at "invitation_token" as "TOKEN"
      Then %{TOKEN} should belong to the new inactive user that was created

    Scenario: Generate invitation token a second time
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
      And I send a POST request to "/api/users/invitation" with the following:
      """
      {
        "user" : {
          "email" : "newuser@gmail.com"
        },
        "auth_token" : "auth_token_123"
      }
      """
      And I send a POST request to "/api/users/invitation" with the following:
      """
      {
        "user" : {
          "email" : "newuser@gmail.com"
        },
        "auth_token" : "auth_token_123"
      }
      """
      Then the response status should be "201"
      And the JSON response should have "invitation_token"
      Given I keep the JSON response at "invitation_token" as "TOKEN"
      Then %{TOKEN} should belong to the new inactive user that was created
      And "newuser@gmail.com" should receive no email

    Scenario: Generate invitation token for existing user
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
      And I send a POST request to "/api/users/invitation" with the following:
      """
      {
        "user" : {
          "email" : "user@gmail.com"
        },
        "auth_token" : "auth_token_123"
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      {"errors" : ["Email has already been taken"]}
      """


    Scenario: Invalid authentication token in params
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
      And I send a POST request to "/api/users/invitation" with the following:
      """
      {
        "user" : {
          "email" : "newuser@gmail.com"
        },
        "auth_token" : "auth_token_1234"
      }
      """
      Then the response status should be "401"
      And the JSON response should not have "invitation_token"
      Then the JSON response should be:
      """
      {"errors": ["Invalid login credentials"]}
      """

    Scenario: Invalid authentication token in the HTTP auth header
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_1234" with the password "X"
      And I send a POST request to "/api/users/invitation" with the following:
      """
      {
        "user" : {
          "email" : "newuser@gmail.com"
        }
      }
      """
      Then the response status should be "401"
      And the JSON response should not have "invitation_token"
      Then the JSON response should be:
      """
      {"errors": ["Invalid login credentials"]}
      """
