# Cucumber API Steps

A set of [Cucumber](https://github.com/aslakhellesoy/cucumber) step definitions utilizing
[Rack-Test](https://github.com/brynary/rack-test) that ease basic
testing of REST-style APIs using either XML or JSON formats.

Adapted from [a blog post by Anthony Eden](http://www.anthonyeden.com/2010/11/testing-rest-apis-with-cucumber-and-rack-test/) with a few additions based on my own needs.  I found myself copying these step definitions around to multiple projects, and decided that it would be worthwhile to gem them up to keep things nice and DRY.

## Dependencies

Requires [Cucumber](https://github.com/aslakhellesoy/cucumber) (obviously).  Also makes use of [JSONPath](https://github.com/joshbuddy/jsonpath) for setting criteria against JSON responses.  See the gemspec for more info.

## Installation

Add the following line to your Gemfile, preferably in the test or cucumber group:

    gem 'cucumber-api-steps', :require => false

Then add the following line to your env.rb to make the step definitions available in your features:

    require 'cucumber/api_steps'
  
# Usage

Still a work in progress.  For now, read the api_steps.rb file or check out the [stashboard-rails](https://github.com/jayzes/stashboard-rails) project - its Cucumber features make extensive use of the steps in this gem.  

One major caveat is that the way the steps are currently built, the PUT and POST steps accept a heredoc-style string (demarcated with lines of three double quotes) as a body, instead of a hash as many people seem to expect.  I found this way to be more natural/flexible for how I write API tests, but it seems like others do not, so I'll be changing the steps to accept either a hash or a string soon.

# Contributors
* Jay Zeschin
* Justin Smestad

## Copyright

Copyright (c) 2011 Jay Zeschin. Distributed under the MIT License.
