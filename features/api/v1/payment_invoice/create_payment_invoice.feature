Feature: Create Payment Invcoice

    Background:
      Given I send and accept JSON

    Scenario: Successfully create payment invoice record
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "kanari_admin"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a POST request to "/api/payment_invoices" with the following:
      """
      {
        "payment_invoice" : {
          "kanari_invoice_id" : 100,
          "receipt_date" : "10-10-2012",
          "amount_paid" : "100"
        }
      }
      """
      Then the response status should be "201"
      And the JSON response should be:
      """
      null
      """

    Scenario: User not authenticated
      When I send a POST request to "/api/payment_invoices" with the following:
      """
      {
        "payment_invoice" : {
          "kanari_invoice_id" : 100,
          "receipt_date" : "10-10-2012",
          "amount_paid" : "100"
        }
      }
      """
      Then the response status should be "401"
      And the JSON response should be:
      """
      {
        "errors" : ["Invalid login credentials"]
      }
      """
