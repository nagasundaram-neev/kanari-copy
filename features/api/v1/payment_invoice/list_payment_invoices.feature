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
        |customer_id  |receipt_date |kanari_invoice_id |amount_paid  |outlet_id    |kanari_plan |invoice_url                           |
        |100          |21-01-2013   |100               |100          |10           |3_months    |kanari.s3.amazonaws.com/file/123.pdf  |
        |100          |23-01-2013   |101               |300          |30           |6_months    |kanari.s3.amazonaws.com/file/234.pdf  |
        |100          |24-01-2013   |102               |400          |40           |9_months    |kanari.s3.amazonaws.com/file/345.pdf  |
        |100          |25-01-2013   |103               |500          |50           |3_months    |kanari.s3.amazonaws.com/file/456.pdf  |
        |101          |23-01-2013   |104               |300          |90           |6_months    |kanari.s3.amazonaws.com/file/567.pdf  |
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/payment_invoices" with the following:
      """
	  start_time=2013-01-22 00:00:00&end_time=2013-01-24 00:00:00
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "payment_invoices": [
          {
            "amount_paid": "300",
            "kanari_plan": "6_months",
            "kanari_invoice_id": 101,
            "invoice_url": "kanari.s3.amazonaws.com/file/234.pdf",
            "outlet_id": 30,
            "receipt_date": "2013-01-23T00:00:00.000Z"
          },
          {
            "amount_paid": "400",
            "kanari_plan": "9_months",
            "kanari_invoice_id": 102,
            "invoice_url": "kanari.s3.amazonaws.com/file/345.pdf",
            "outlet_id": 40,
            "receipt_date": "2013-01-24T00:00:00.000Z"
          }
        ]
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
        |customer_id  |receipt_date |kanari_invoice_id |amount_paid  |outlet_id    |kanari_plan |invoice_url                           |
        |100          |21-01-2013   |100               |100          |10           |3_months    |kanari.s3.amazonaws.com/file/123.pdf  |
        |100          |23-01-2013   |101               |300          |30           |6_months    |kanari.s3.amazonaws.com/file/234.pdf  |
        |100          |24-01-2013   |102               |400          |40           |9_months    |kanari.s3.amazonaws.com/file/345.pdf  |
        |100          |25-01-2013   |103               |500          |50           |3_months    |kanari.s3.amazonaws.com/file/456.pdf  |
        |101          |23-01-2013   |104               |300          |90           |6_months    |kanari.s3.amazonaws.com/file/567.pdf  |
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/payment_invoices" with the following:
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "payment_invoices": [
          {
            "amount_paid": "100",
            "kanari_plan": "3_months",
            "kanari_invoice_id": 100,
            "invoice_url": "kanari.s3.amazonaws.com/file/123.pdf",
            "outlet_id": 10,
            "receipt_date": "2013-01-21T00:00:00.000Z"
          },
          {
            "amount_paid": "300",
            "kanari_plan": "6_months",
            "kanari_invoice_id": 101,
            "invoice_url": "kanari.s3.amazonaws.com/file/234.pdf",
            "outlet_id": 30,
            "receipt_date": "2013-01-23T00:00:00.000Z"
          },
          {
            "amount_paid": "400",
            "kanari_plan": "9_months",
            "kanari_invoice_id": 102,
            "invoice_url": "kanari.s3.amazonaws.com/file/345.pdf",
            "outlet_id": 40,
            "receipt_date": "2013-01-24T00:00:00.000Z"
          },
          {
            "amount_paid": "500",
            "kanari_plan": "3_months",
            "kanari_invoice_id": 103,
            "invoice_url": "kanari.s3.amazonaws.com/file/456.pdf",
            "outlet_id": 50,
            "receipt_date": "2013-01-25T00:00:00.000Z"
          }
        ]

      }
      """

   Scenario: Customer doesn't have any payment invoice
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
        And his role is "customer_admin"
      Given a customer named "China Pearl" exists with id "100"
      And a customer named "Mast Kalandar" exists with id "101"
      Given he is the admin for customer "Mast Kalandar"
      And the following payment invoices have been created
        |customer_id  |receipt_date |kanari_invoice_id |amount_paid  |outlet_id    |kanari_plan |invoice_url                           |
        |100          |21-01-2013   |100               |100          |10           |3_months    |kanari.s3.amazonaws.com/file/123.pdf  |
        |100          |23-01-2013   |101               |300          |30           |6_months    |kanari.s3.amazonaws.com/file/234.pdf  |
        |100          |24-01-2013   |102               |400          |40           |9_months    |kanari.s3.amazonaws.com/file/345.pdf  |
        |100          |25-01-2013   |103               |500          |50           |3_months    |kanari.s3.amazonaws.com/file/456.pdf  |
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/payment_invoices" with the following:
      """
	  start_time=2013-01-22 00:00:00&end_time=2013-01-24 00:00:00
      """
      Then the response status should be "200"
      And the JSON response should be:
      """
      {
        "payment_invoices": []
      }
      """

    Scenario: User's role is not customer_admin
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "not_customer_admin"
        And his authentication token is "auth_token_123"
      Given a customer named "China Pearl" exists with id "100"
        And he is the admin for customer "China Pearl"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/payment_invoices" with the following:
      """
	  start_time=2013-01-22 00:00:00&end_time=2013-01-24 00:00:00
      """
      Then the response status should be "403"
      And the JSON response should be:
      """
      {"errors" : ["Insufficient privileges"]}
      """

    Scenario: User is a customer_admin but doesn't have a customer account
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his role is "customer_admin"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_123" with the password "random string"
      And I send a GET request to "/api/payment_invoices"
      Then the response status should be "422"
      And the JSON response should be:
      """
      {"errors" : ["No customer account found"]}
      """

    Scenario: User is not authenticated
      Given "Adam" is a user with email id "user@gmail.com" and password "password123"
        And his authentication token is "auth_token_123"
      When I authenticate as the user "auth_token_1234" with the password "random string"
      And I send a GET request to "/api/payment_invoices" with the following:
      """
	  start_time=2013-01-22 00:00:00&end_time=2013-01-24 00:00:00
      """
      Then the response status should be "401"
      And the JSON response should be:
      """
      {"errors" : ["Invalid login credentials"]}
      """
