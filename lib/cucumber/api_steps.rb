require 'jsonpath'

World(Rack::Test::Methods)

Given /^I send and accept XML$/ do
  page.driver.header 'Accept', 'text/xml'
  page.driver.header 'Content-Type', 'text/xml'
end

Given /^I send and accept JSON$/ do
  page.driver.header 'Accept', 'application/json'
  page.driver.header 'Content-Type', 'application/json'
end

When /^I authenticate as the user "([^\"]*)" with the password "([^\"]*)"$/ do |user, pass|
  page.driver.authorize(user, pass)
end

When /^I send a GET request (?:for|to) "([^\"]*)"$/ do |path|
  page.driver.get path
end

When /^I send a POST request to "([^\"]*)"$/ do |path|
  page.driver.post path
end

When /^I send a POST request to "([^\"]*)" with the following:$/ do |path, body|
  page.driver.post path, body
end

When /^I send a PUT request to "([^\"]*)" with the following:$/ do |path, body|
  page.driver.put path, body
end

When /^I send a DELETE request to "([^\"]*)"$/ do |path|
  page.driver.delete path
end

Then /^show me the response$/ do
  p page.driver.last_response
end

Then /^the response status should be "([^\"]*)"$/ do |status|
  if page.respond_to? :should
    page.driver.last_response.status.should == status.to_i
  else
    assert page.driver.last_response.status == status.to_i
  end
end

Then /^the JSON response should have "([^\"]*)" with the text "([^\"]*)"$/ do |json_path, text|
  json    = JSON.parse(page.driver.last_response.body)
  results = JsonPath.new(json_path).on(json).to_a.map(&:to_s)
  if page.respond_to? :should
    results.should include(text)
  else
    assert results.include?(text)
  end
end

Then /^the JSON response should not have "([^\"]*)" with the text "([^\"]*)"$/ do |json_path, text|
  json    = JSON.parse(page.driver.last_response.body)
  results = JsonPath.new(json_path).on(json).to_a.map(&:to_s) 
  if page.respond_to? :should
    results.should_not include(text)
  else
    assert !results.include?(text)
  end
end

Then /^the XML response should have "([^\"]*)" with the text "([^\"]*)"$/ do |xpath, text|
  parsed_response = Nokogiri::XML(last_response.body)
  elements = parsed_response.xpath(xpath)
  elements.should_not be_empty, "could not find #{xpath} in:\n#{last_response.body}"
  elements.find { |e| e.text == text }.should_not be_nil, "found elements but could not find #{text} in:\n#{elements.inspect}"
end