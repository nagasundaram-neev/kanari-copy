Feature: Vaidate Kanari Code

    Background:
      Given I send and accept JSON

    Scenario: Kanari code is valid
      Given a customer named "Taj" exists with id "100" with admin "admin@subway.com"
	    And the customer with id "100" has an outlet named "Taj - Mumbai" with id "10" with manager "manager@taj.com"
      Given A feedback exists with the following attributes:
        |id        |1      |
        |code      |12345  |
        |outlet_id |10     |
      When I send a GET request to "/api/kanari_codes/12345"
      Then the response status should be "200"
      And the JSON response should be:
      """
      {"feedback_id" : 1, "outlet_name" : "Taj - Mumbai"}
      """

    Scenario: Kanari code is invalid
      When I send a GET request to "/api/kanari_codes/12345"
      Then the response status should be "422"
      And the JSON response should be:
      """
      {"errors": ["Invalid code"]}
      """
