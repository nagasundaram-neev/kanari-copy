Feature: Accept invitation

    Background:
      Given I send and accept JSON

    Scenario: Successfully accept an invitation
      Given "user@gmail.com" received an invitation with token "invitation_token_123"
      When I send a PUT request to "/api/users/invitation" with the following:
      """
      {
        "user" : {
          "password" : "testpassword",
          "password_confirmation": "testpassword",
          "name": "John Doe",
          "invitation_token": "invitation_token_123"
        }
      }
      """
      Then the response status should be "200"
      And the JSON response should have "auth_token"

    Scenario: Invalid invitation_token
      Given I send a PUT request to "/api/users/invitation" with the following:
      """
      {
        "user" : {
          "password" : "testpassword",
          "password_confirmation": "testpassword",
          "name": "John Doe",
          "invitation_token": "invalid_auth_token"
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      { "errors" : ["Invitation token is invalid"] }
      """

    Scenario: Passwords do not match
      Given "user@gmail.com" received an invitation with token "invitation_token_123"
      When I send a PUT request to "/api/users/invitation" with the following:
      """
      {
        "user" : {
          "password" : "testpassword",
          "password_confirmation": "testpassword123",
          "name": "John Doe",
          "invitation_token": "invitation_token_123"
        }
      }
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      {"errors": ["Password confirmation doesn't match Password"]}
      """
