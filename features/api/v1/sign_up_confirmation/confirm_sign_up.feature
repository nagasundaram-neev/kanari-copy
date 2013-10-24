Feature: Confirm sign up

    Background:
      Given I send and accept JSON

    Scenario: Successfully confirm sign up
      Given "user@gmail.com" received a confirmation mail with token "confirmation_token_123"
      When I send a GET request to "/api/users/confirmation" with the following:
      """
      confirmation_token=confirmation_token_123
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      null
      """

    Scenario: Invalid confirmation token
      Given "user@gmail.com" received a confirmation mail with token "confirmation_token_123"
      When I send a GET request to "/api/users/confirmation" with the following:
      """
      confirmation_token=confirmation_token_1234
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      { "errors" : ["Confirmation token is invalid"] }
      """

    Scenario: Blank confirmation token
      Given "user@gmail.com" received a confirmation mail with token "confirmation_token_123"
      When I send a GET request to "/api/users/confirmation" with the following:
      """
      null
      """
      Then the response status should be "422"
      And the JSON response should be:
      """
      { "errors" : ["Confirmation token can't be blank"] }
      """
