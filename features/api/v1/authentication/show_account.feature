Feature: Show User account

    Background:
      Given I send and accept JSON

    Scenario: Successfully show user details
      Given the following user exists
        |id|100|
        |email|user@gmail.com|
        |first_name |Kobe|
        |last_name|Bryant|
        |password| password123|
        |authentication_token|user_auth_token|
        |role|user|
        |points_available|100|
        |points_redeemed|50|
        |redeems_count|1|
        |location|SF|
        |gender|Male|
        |date_of_birth|1987-05-06|
        |phone_number|1234567890|
      When I authenticate as the user "user_auth_token" with the password "random string"
      And I send a GET request to "/api/users"
      Then the response status should be "200"
      And the JSON response should be:
      """
       {
         "user": {
           "id" : 100,
           "date_of_birth": "1987-05-06",
           "email": "user@gmail.com",
           "first_name": "Kobe",
           "gender": "Male",
           "last_name": "Bryant",
           "location": "SF",
           "phone_number": "1234567890",
           "points_available": 100,
           "redeems_count": 1,
           "points_redeemed": 50
         }
       }
      """

    Scenario: User is not authenticated
      When I authenticate as the user "invalid_auth_token" with the password "random string"
      And I send a GET request to "/api/users"
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors" : ["Invalid login credentials"]}
      """
