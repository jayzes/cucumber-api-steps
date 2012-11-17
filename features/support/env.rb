require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support
require 'pry'

require 'rack'
require 'rack/test'
require File.dirname(__FILE__) + "/../fixtures/fake_app"

require 'cucumber/api_steps'

def app
  Rack::Lint.new(Rack::Test::FakeApp.new)
end
