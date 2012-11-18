Feature:
  As cucumber tester
  I want to test basic authentication

  Scenario: Basic authentication
    When I perform the following steps:
      """
      I authenticate as the user "joe" with the password "god"
      I send a GET request for "/"
      """
    Then I should be authenticated


  @digest-auth
  Scenario: Successful digest authentication
    When I perform the following steps:
      """
      I digest-authenticate as the user "joe" with the password "god"
      I send a GET request for "/"
      """
    Then I should be digest authenticated
