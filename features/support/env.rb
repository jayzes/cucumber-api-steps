require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support
require 'capybara/cucumber'

# Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
# order to ease the transition to Capybara we set the default here. If you'd
# prefer to use XPath just remove this line and adjust any selectors in your
# steps to use the XPath syntax.
Capybara.default_selector = :css
Capybara.default_driver = :rack_test

require 'cucumber/api_steps'