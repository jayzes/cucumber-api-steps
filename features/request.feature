Feature:

  Scenario: GET request
    When I perform the following step:
      """
      I send a GET request to "/api/books"
      """
    Then the response status should be "200"

  Scenario: GET request with defined instance variable method referenced from step
    Given I define instance variable @defined = "BOOKS"
    When I perform the following step:
      """
      I send a GET request to "/api/[@defined.downcase]"
      """
    Then the response status should be "200"

  Scenario: GET request with undefined instance variable referenced from step
    When I perform the following steps which may raise ArgumentError:
      """
      I send a GET request to "/api/[@undefined]"
      """
    Then ArgumentError was raised

  Scenario: POST request with params
    When I perform the following step with table:
      """
      I send a POST request to "/api/books" with the following:
      | title     | Metaprograming ruby |
      | publisher | Pragprog            |
      """
    Then the response status should be "201"

  Scenario: POST request with string
    When I perform the following step with string:
      """
      I send a POST request to "/api/publishers" with the following:
      {"publisher": "Pragprog"}
      """
    Then the response status should be "201"

  Scenario: PUT request with defined instance variable method referenced from step
    Given I define instance variable @publisher = OpenStruct.new(:id => 123)
    When I perform the following step with string:
      """
      I send a PUT request to "/api/publishers/[@publisher.id]" with the following:
      {"publisher": "Pragprog"}
      """
    Then the response status should be "200"
