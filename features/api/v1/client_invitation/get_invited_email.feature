Feature: Get invited email

    Background:
      Given I send and accept JSON

    Scenario: Invitation token is valid
      Given "user@gmail.com" received an invitation with token "invitation_token_123"
      When I send a GET request to "/api/users/invitation/invitation_token_123"
      Then the response status should be "200"
      And the JSON response should be:
      """
      { "email" : "user@gmail.com" }
      """

    Scenario: Invitation token is invalid
      When I send a GET request to "/api/users/invitation/invitation_token_123"
      Then the response status should be "422"
      And the JSON response should be:
      """
      { "errors" : ["Invalid invitation token"] }
      """
