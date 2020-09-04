require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support
require 'pry'

require 'cucumber/api_steps'

Before do
    @base_url = "http://localhost:4567"
end