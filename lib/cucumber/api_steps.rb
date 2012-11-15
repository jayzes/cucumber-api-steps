require 'jsonpath'

if defined?(Rack)

  # Monkey patch Rack::MockResponse to work properly with response debugging
  class Rack::MockResponse
    def to_str
      body
    end
  end

  World(Rack::Test::Methods)

end

Given /^I send and accept "(.*?)"$/ do |type|
  page.driver.header 'Accept', type
end

Given /^I send and accept (XML|JSON)$/ do |type|
  page.driver.header 'Accept', "application/#{type.downcase}"
  page.driver.header 'Content-Type', "application/#{type.downcase}"
end

Given /^I send and accept HTML$/ do
  page.driver.header 'Accept', "text/html"
  page.driver.header 'Content-Type', "application/x-www-form-urlencoded"
end

When /^I authenticate as the user "([^"]*)" with the password "([^"]*)"$/ do |user, pass|
  if page.driver.respond_to?(:basic_auth)
    page.driver.basic_auth(user, pass)
  elsif page.driver.respond_to?(:basic_authorize)
    page.driver.basic_authorize(user, pass)
  elsif page.driver.respond_to?(:browser) && page.driver.browser.respond_to?(:basic_authorize)
    page.driver.browser.basic_authorize(user, pass)
  elsif page.driver.respond_to?(:authorize)
    page.driver.authorize(user, pass)
  else
    raise "Can't figure out how to log in with the current driver!"
  end
end

When /^I send a (GET|POST|PUT|DELETE) request (?:for|to) "([^"]*)"(?: with the following:)?$/ do |*args|
  request_type = args.shift
  path = args.shift
  body = args.shift
  if body.present?
    page.driver.send(request_type.downcase.to_sym, path, body)
  else
    page.driver.send(request_type.downcase.to_sym, path)
  end
end

Then /^show me the response$/ do
  json_response = JSON.parse(page.driver.response)
  puts JSON.pretty_generate(json_response)
end

Then /^the response status should be "([^"]*)"$/ do |status|
  if page.respond_to? :should
    page.driver.response.status.should == status.to_i
  else
    assert_equal status.to_i, page.driver.response.status
  end
end

Then /^the JSON response should (not)?\s?have "([^"]*)" with the text "([^"]*)"$/ do |negative, json_path, text|
  json    = JSON.parse(page.driver.response.body)
  results = JsonPath.new(json_path).on(json).to_a.map(&:to_s)
  if page.respond_to?(:should)
    if negative.present?
      results.should_not include(text)
    else
      results.should include(text)
    end
  else
    if negative.present?
      assert !results.include?(text)
    else
      assert results.include?(text)
    end
  end
end

Then /^the XML response should have "([^"]*)" with the text "([^"]*)"$/ do |xpath, text|
  parsed_response = Nokogiri::XML(page.body)
  elements = parsed_response.xpath(xpath)
  if page.respond_to?(:should)
    elements.should_not be_empty, "could not find #{xpath} in:\n#{page.body}"
    elements.find { |e| e.text == text }.should_not be_nil, "found elements but could not find #{text} in:\n#{elements.inspect}"
  else
    assert !elements.empty?, "could not find #{xpath} in:\n#{last_response.body}"
    assert elements.find { |e| e.text == text }, "found elements but could not find #{text} in:\n#{elements.inspect}"
  end
end

Then 'the JSON response should be:' do |json|
  expected = JSON.parse(json)
  actual = JSON.parse(page.driver.response.body)

  if page.respond_to?(:should)
    actual.should == expected
  else
    assert_equal actual, response
  end
end

Then /^the JSON response should have "([^"]*)" with a length of (\d+)$/ do |json_path, length|
  json = JSON.parse(page.driver.response.body)
  results = JsonPath.new(json_path).on(json)
  if page.respond_to?(:should)
    results.first.length.should == length.to_i
  else
    assert_equal length.to_i, results.first.length
  end
end
