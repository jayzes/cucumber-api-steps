Feature:
  As cucumber tester
  I should be able to set headers for request

  Scenario: Set multiple headers
    When I perform the following step with table:
      """
      I set headers:
        | Accept     | application/vnd.myproject.v1 |
        | User-Agent | Cucumber Api Steps Client   |
      """
    Then the request headers should be:
      | Accept     | application/vnd.myproject.v1 |
      | User-Agent | Cucumber Api Steps Client    |

  Scenario: Send and accept JSON
    When I perform the following step:
      """
      I send and accept JSON
      """
    Then the request headers should be:
      | Accept  | application/json |
      | Content-Type | application/json |

  Scenario: Send and accept HTML
    When I perform the following step:
      """
      I send and accept HTML
      """
    Then the request headers should be:
      | Accept  | text/html                         |
      | Content-Type | application/x-www-form-urlencoded |
