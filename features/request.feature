Feature:

  Scenario: GET request
    When I perform the following step:
      """
      I send a GET request to "/api/books"
      """
    Then the response status should be "200"

  Scenario: POST request with params
    When I perform the following step with table:
      """
      I send a POST request to "/api/books" with the following:
      | title     | Metaprograming ruby |
      | publisher | Pragprog            |
      """
    Then the response status should be "201"

  Scenario: PATCH request with params
    When I perform the following step with table:
      """
      I send a PATCH request to "/api/books" with the following:
      | title     | Metaprograming ruby |
      | publisher | Pragprog            |
      """
    Then the response status should be "200"

  Scenario: POST request with string
    When I perform the following step with string:
      """
      I send a POST request to "/api/publishers" with the following:
      {"publisher": "Pragprog"}
      """
    Then the response status should be "201"
