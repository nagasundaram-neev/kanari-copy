Feature: Client Registration
  In order to create a user account in the application
  A client
  Should be able to sign up

    Scenario: Successful registration
      Given "Adam" is a client with email id "hellomisteradam@gmail.com"
        And he is invited to create an account on the site
      Then he receives an email with a link to the registration process
      When he clicks on the link to the registration process
      Then he is taken to a page to fill in account information
      When he fills in the required information in registration page
        And he fills in password and password confirmation as "adam123"
        And submits the registration form
      Then user with email "hellomisteradam@gmail.com" should be registered
      And "Adam" should be logged in
