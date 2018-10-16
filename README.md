# cucumber-api-steps

[![Build Status](https://travis-ci.org/jayzes/cucumber-api-steps.png)](https://travis-ci.org/jayzes/cucumber-api-steps)
[![Gem Version](https://badge.fury.io/rb/cucumber-api-steps.png)](http://badge.fury.io/rb/cucumber-api-steps)

A set of [Cucumber](https://github.com/cucumber/cucumber) step definitions utilizing
[Rack-Test](https://github.com/brynary/rack-test) that ease basic
testing of REST-style APIs using either XML or JSON formats.

Adapted from [a blog post by Anthony Eden](http://anthonyeden.com/2013/07/10/testing-rest-apis-with-cucumber-and-rack.html) with a few additions based on my own needs.  I found myself copying these step definitions around to multiple projects, and decided that it would be worthwhile to gem them up to keep things nice and DRY.

## Dependencies

Requires [Cucumber](https://github.com/aslakhellesoy/cucumber) (obviously).  Also makes use of [JSONPath](https://github.com/joshbuddy/jsonpath) for setting criteria against JSON responses.  See the gemspec for more info.

## Installation

Add the following line to your Gemfile, preferably in the test or cucumber group:

```ruby
gem 'cucumber-api-steps', :require => false
```

Then add the following line to your env.rb to make the step definitions available in your features:

```ruby
require 'cucumber/api_steps'
```

# Usage

Still a work in progress.  For now, read the api_steps.rb file or check out the [stashboard-rails](https://github.com/jayzes/stashboard-rails) project - its Cucumber features make extensive use of the steps in this gem.

# Examples
```cucumber
Feature: API

  Scenario: List tweets in JSON
    When I send and accept JSON
    And I send a GET request to "/api/tweets"
    Then the response status should be "200"
    And the JSON response should be:
      """
      [{"tweet":"Hello World!"},{"tweet":"New Rails has been released"}]
      """
    And the JSON response should have "$..tweet" with the text "Hello World!"
    And the JSON response should have "$..tweet" with a length of 2

  Scenario: List tweets in XML
    When I send and accept XML
    And I send a GET request to "/api/tweets"
    Then the XML response should have "tweet" with the text "Hello World!"

  Scenario: Post tweet using POST-params
    When I send a POST request to "/api/tweets" with the following:
      | tweet | Hello World! |
      | lat   | 42.848282    |
      | lng   | 74.634933    |
    Then the response status should be "201"

  Scenario: Post tweet using json in POST body
    When I send a POST request to "/api/tweets" with the following:
      """
      {"tweet":"Hello World!","lat":"42.848282", "lng":"74.634933"}
      """
    Then the response status should be "201"

  Scenario: Basic authentication
    When I authenticate as the user "joe" with the password "password123"
    And I send a GET request to "/api/tweets"
    Then the response status should be "200"

  Scenario: Digest authentication
    When I digest-authenticate as the user "joe" with the password "password123"
    And I send a GET request to "/api/tweets"
    Then the response status should be "200"
```
# Contributors
* Jay Zeschin
* Justin Smestad
* Kevin Pfefferle
* Kalys Osmonov
* Mingding Han
* Gabe Varela
* Steven Heidel
* Adam Elhardt
* Gonzalo Bulnes Guilpain

## Copyright

Copyright (c) 2011 Jay Zeschin. Distributed under the MIT License.
