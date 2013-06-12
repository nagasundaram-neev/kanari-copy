Feature: Vaidate Kanari Code

    Background:
      Given I send and accept JSON

    Scenario: Kanari code is valid
      Given A feedback exists with the following attributes:
        |id   |10     |
        |code |12345  |
      When I send a GET request to "/api/kanari_codes/12345"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {"feedback_id" : 10}
      """

    Scenario: Kanari code is invalid
      When I send a GET request to "/api/kanari_codes/12345"
      Then the response status should be "422"
      And the JSON response should be:
      """
      {"errors": ["Invalid code"]}
      """
