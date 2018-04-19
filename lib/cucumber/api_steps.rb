require 'jsonpath'
require 'nokogiri'

if defined?(Rack)

  # Monkey patch Rack::MockResponse to work properly with response debugging
  class Rack::MockResponse
    def to_str
      body
    end
  end

  World(Rack::Test::Methods)

end

Given /^I set headers:$/ do |headers|
  headers.rows_hash.each {|k,v| header k, v }
end

Given /^I send and accept (XML|JSON)$/ do |type|
  header 'Accept', "application/#{type.downcase}"
  header 'Content-Type', "application/#{type.downcase}"
end

Given /^I send and accept HTML$/ do
  header 'Accept', "text/html"
  header 'Content-Type', "application/x-www-form-urlencoded"
end

When /^I authenticate as the user "([^"]*)" with the password "([^"]*)"$/ do |user, pass|
  authorize user, pass
end

When /^I digest\-authenticate as the user "(.*?)" with the password "(.*?)"$/ do |user, pass|
  digest_authorize user, pass
end

When /^I send a (GET|PATCH|POST|PUT|DELETE) request (?:for|to) "([^"]*)"(?: with the following:)?$/ do |*args|
  request_type = args.shift
  path = args.shift
  input = args.shift

  request_opts = {method: request_type.downcase.to_sym}

  unless input.nil?
    if input.class == Cucumber::MultilineArgument::DataTable
      request_opts[:params] = input.rows_hash
    else
      request_opts[:input] = StringIO.new input
    end
  end

  request path, request_opts
end

Then /^show me the (unparsed)?\s?response$/ do |unparsed|
  if unparsed == 'unparsed'
    puts last_response.body
  elsif last_response.headers['Content-Type'] =~ /json/
    json_response = JSON.parse(last_response.body)
    puts JSON.pretty_generate(json_response)
  elsif last_response.headers['Content-Type'] =~ /xml/
    puts Nokogiri::XML(last_response.body)
  else
    puts last_response.headers
    puts last_response.body
  end
end

Then /^the response status should be "([^"]*)"$/ do |status|
  if self.respond_to?(:expect)
    expect(last_response.status).to eq(status.to_i)
  else
    assert_equal status.to_i, last_response.status
  end
end

Then /^the JSON response should (not)?\s?have "([^"]*)"$/ do |negative, json_path|
  json    = JSON.parse(last_response.body)
  results = JsonPath.new(json_path).on(json).to_a.map(&:to_s)
  if self.respond_to?(:expect)
    if negative.present?
      expect(results).to be_empty
    else
      expect(results).not_to be_empty
    end
  else
    if negative.present?
      assert results.empty?
    else
      assert !results.empty?
    end
  end
end


Then /^the JSON response should (not)?\s?have "([^"]*)" with the text "([^"]*)"$/ do |negative, json_path, text|
  json    = JSON.parse(last_response.body)
  results = JsonPath.new(json_path).on(json).to_a.map(&:to_s)
  if self.respond_to?(:expect)
    if negative.present?
      expect(results).not_to include(text)
    else
      expect(results).to include(text)
    end
  else
    if negative.present?
      assert !results.include?(text)
    else
      assert results.include?(text)
    end
  end
end

Then /^the XML response should (not)?\s?have "([^"]*)"$/ do |negative, xpath|
  parsed_response = Nokogiri::XML(last_response.body)
  elements = parsed_response.xpath(xpath)
  if self.respond_to?(:expect)
    if negative.present?
      expect(elements).to be_empty
    else
      expect(elements).not_to be_empty
    end
  else
    if negative.present?
      assert elements.empty?
    else
      assert !elements.empty?
    end
  end
end

Then /^the XML response should have "([^"]*)" with the text "([^"]*)"$/ do |xpath, text|
  parsed_response = Nokogiri::XML(last_response.body)
  elements = parsed_response.xpath(xpath)
  if self.respond_to?(:expect)
    expect(elements).not_to be_empty, "could not find #{xpath} in:\n#{last_response.body}"
    expect(elements.find { |e| e.text == text }).not_to be_nil, "found elements but could not find #{text} in:\n#{elements.inspect}"
  else
    assert !elements.empty?, "could not find #{xpath} in:\n#{last_response.body}"
    assert elements.find { |e| e.text == text }, "found elements but could not find #{text} in:\n#{elements.inspect}"
  end
end

Then /^the JSON response should be:$/ do |json|
  expected = JSON.parse(json)
  actual = JSON.parse(last_response.body)

  if self.respond_to?(:expect)
    expect(actual).to eq(expected)
  else
    assert_equal expected, actual
  end
end

Then /^the JSON response should have "([^"]*)" with a length of (\d+)$/ do |json_path, length|
  json = JSON.parse(last_response.body)
  results = JsonPath.new(json_path).on(json)
  if self.respond_to?(:expect)
    expect(results.length).to eq(length.to_i)
  else
    assert_equal length.to_i, results.length
  end
end
