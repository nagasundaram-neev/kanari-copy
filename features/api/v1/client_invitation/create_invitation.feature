Feature: Create invitation

    Background:
      Given I send and accept JSON

    Scenario: Successful create an invitation
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

