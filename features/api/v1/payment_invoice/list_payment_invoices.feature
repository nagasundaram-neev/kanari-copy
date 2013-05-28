Feature: List Payment Invcoices

    Background:
      Given I send and accept JSON

    Scenario: Successfully list payment invoice records
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
        And his role is "customer_admin"
      Given a customer named "China Pearl" exists with id "100"
      And a customer named "Mast Kalandar" exists with id "101"
      Given he is the admin for customer "China Pearl"
      And the following payment invoices have been created
        |customer_id  |   receipt_date  |   amount_paid   |
        |100          |   21-01-2013    |   100           |
        |100          |   23-01-2013    |   300           |
        |100          |   24-01-2013    |   400           |
        |100          |   25-01-2013    |   500           |
        |101          |   23-01-2013    |   300           |
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/customers/100/payment_invoices" with the following:
      """
      start_date=22-01-2013&end_date=24-01-2013
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "payment_invoices": [
          {
            "amount_paid": "300",
            "kanari_invoice_id": null,
            "receipt_date": "2013-01-23T00:00:00.000Z"
          },
          {
            "amount_paid": "400",
            "kanari_invoice_id": null,
            "receipt_date": "2013-01-24T00:00:00.000Z"
          }
        ]
      }
      """

    Scenario: User is not the admin of the customer account
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
        And his role is "customer_admin"
      Given a customer named "China Pearl" exists with id "100"
      And a customer named "Mast Kalandar" exists with id "101"
      Given he is the admin for customer "China Pearl"
      And the following payment invoices have been created
        |customer_id  |   receipt_date  |   amount_paid   |
        |100          |   21-01-2013    |   100           |
        |100          |   23-01-2013    |   300           |
        |100          |   24-01-2013    |   400           |
        |100          |   25-01-2013    |   500           |
        |101          |   23-01-2013    |   300           |
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/customers/101/payment_invoices" with the following:
      """
      start_date=22-01-2013&end_date=24-01-2013
      """
      Then the response status should be "400"
      And the JSON response should be:
      """
      {"errors": ["Invalid customer ID"]}
      """

    Scenario: User's role is not customer_admin
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "not_customer_admin"
        And his authentication token is "auth_token_123"
      Given a customer named "China Pearl" exists with id "100"
        And he is the admin for customer "China Pearl"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/customers/100/payment_invoices" with the following:
      """
      start_date=22-01-2013&end_date=24-01-2013
      """
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors" : ["Insufficient privileges"]}
      """

    Scenario: User is not authenticated
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_1234" with the password "random string"
      And I send a GET request to "/api/customers/100/payment_invoices" with the following:
      """
      start_date=22-01-2013&end_date=24-01-2013
      """
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors" : ["Invalid login credentials"]}
      """

    Scenario: Customer doesn't have any payment invoice
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
        And his role is "customer_admin"
      Given a customer named "China Pearl" exists with id "100"
      And a customer named "Mast Kalandar" exists with id "101"
      Given he is the admin for customer "Mast Kalandar"
      And the following payment invoices have been created
        |customer_id  |   receipt_date  |   amount_paid   |
        |100          |   21-01-2013    |   100           |
        |100          |   23-01-2013    |   300           |
        |100          |   24-01-2013    |   400           |
        |100          |   25-01-2013    |   500           |
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/customers/101/payment_invoices" with the following:
      """
      start_date=22-01-2013&end_date=24-01-2013
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "payment_invoices": []
      }
      """

    Scenario: User doesn't provide a date range
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
        And his role is "customer_admin"
      Given a customer named "China Pearl" exists with id "100"
      And a customer named "Mast Kalandar" exists with id "101"
      Given he is the admin for customer "China Pearl"
      And the following payment invoices have been created
        |customer_id  |   receipt_date  |   amount_paid   |
        |100          |   21-01-2013    |   100           |
        |100          |   23-01-2013    |   300           |
        |100          |   24-01-2013    |   400           |
        |100          |   25-01-2013    |   500           |
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/customers/100/payment_invoices" with the following:
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "payment_invoices": [
          {
            "amount_paid": "100",
            "kanari_invoice_id": null,
            "receipt_date": "2013-01-21T00:00:00.000Z"
          },
          {
            "amount_paid": "300",
            "kanari_invoice_id": null,
            "receipt_date": "2013-01-23T00:00:00.000Z"
          },
          {
            "amount_paid": "400",
            "kanari_invoice_id": null,
            "receipt_date": "2013-01-24T00:00:00.000Z"
          },
          {
            "amount_paid": "500",
            "kanari_invoice_id": null,
            "receipt_date": "2013-01-25T00:00:00.000Z"
          }
        ]

      }
      """
