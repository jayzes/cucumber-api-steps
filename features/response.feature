Feature:
  As cucumber tester
  I want to test response

  Scenario: Test response status
    When I perform the following step:
      """
      I send a GET request to "/"
      """

    Then the response status should be "200"

  Scenario: Test if JSON response contains text
    When I perform the following step:
      """
      I send a GET request to "/api/books"
      """
    Then the JSON response should have "$..title" with the text "Metaprograming ruby"

  Scenario: Test if JSON response doesn't contain text
    When I perform the following step:
      """
      I send a GET request to "/api/books"
      """
    Then the JSON response should not have "$..publisher" with the text "Metaprograming ruby"

  Scenario: Test if XML response contains text
    When I send and accept XML
    And I perform the following step:
      """
      I send a GET request to "/api/books"
      """
    Then the XML response should have "//title" with the text "Metaprograming ruby"

  Scenario: Test JSON response
    When I perform the following step:
      """
      I send a GET request to "/api/books"
      """
    Then the JSON response should be:
      """
      {"books":[{"title":"Pride and prejudice"},{"title":"Metaprograming ruby"}]}
      """

  Scenario: Test JSON with length of some element
    When I perform the following step:
      """
      I send a GET request to "/api/books"
      """
    Then the JSON response should have "$..title" with a length of 2

  Scenario: Test debugging the XML response should not blow up
    When I send and accept XML
    And I perform the following step:
      """
      I send a GET request to "/api/books"
      """
    Then show me the response

  Scenario: Test debugging the JSON response should not blow up
    When I send and accept JSON
    And I perform the following step:
      """
      I send a GET request to "/api/books"
      """
    Then show me the response

