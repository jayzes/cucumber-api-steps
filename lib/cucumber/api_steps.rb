require 'jsonpath'
require 'httparty'

def initialize
  @headers = {}
  @request = {}
end

Given /^I set headers:$/ do |headers|
  headers.rows_hash.each {|k,v| header k, v }
end

Given /^I send and accept (JSON)$/ do |type|
  header 'Accept', "application/#{type.downcase}"
  header 'Content-Type', "application/#{type.downcase}"
end

Given /^I send and accept HTML$/ do
  header 'Accept', "text/html"
  header 'Content-Type', "application/x-www-form-urlencoded"
end

When /^I authenticate as the user "([^"]*)" with the password "([^"]*)"$/ do |user, pass|
  basic_authorize user, pass
end

When /^I digest\-authenticate as the user "(.*?)" with the password "(.*?)"$/ do |user, pass|
  digest_authorize user, pass
end

When /^I send a (GET|PATCH|POST|PUT|DELETE) request (?:for|to) "([^"]*)"(?: with the following:)?$/ do |*args|
  request_type = args.shift.downcase
  path = args.shift
  input = args.shift

  if path.include?("http:") || path.include?("https:")
    url = path
  else
    url = @base_url + path
  end

  options = {}
  options[:headers] = @headers
  unless input.nil?
    if input.class == Cucumber::MultilineArgument::DataTable
      options[:query] = input.rows_hash
    else
      options[:body] = input
    end
  end
  
  @request[:type] = request_type
  @request[:url] = url
  @request[:options] = options
  
  @response = HTTParty.send(@request[:type], @request[:url], @request[:options])
  @response_body = JSON.parse(@response.body) rescue 'No Response Body from Server'
  @response_code = @response.code
end

Then /^show me the (unparsed)?\s?response$/ do |unparsed|
  if unparsed == 'unparsed'
    Kernel.puts @response.body
  elsif @response.headers['Content-Type'] =~ /json/
    json_response = JSON.parse(@response.body)
    Kernel.puts JSON.pretty_generate(json_response)
  else
    Kernel.puts @response.headers
    Kernel.puts @response.body
  end
end

Then /^the response status should be "([^"]*)"$/ do |status|
  if self.respond_to?(:expect)
    expect(@response.code).to eq(status.to_i)
  else
    assert_equal status.to_i, @response.code
  end
end

Then /^the JSON response should (not)?\s?have "([^"]*)"$/ do |negative, json_path|
  json    = JSON.parse(@response.body)
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
  json    = JSON.parse(@response.body)
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

Then /^the JSON response should be:$/ do |json|
  expected = JSON.parse(json)
  actual = JSON.parse(@response.body)

  if self.respond_to?(:expect)
    expect(actual).to eq(expected)
  else
    assert_equal expected, actual
  end
end

Then /^the JSON response should have "([^"]*)" with a length of (\d+)$/ do |json_path, length|
  json = JSON.parse(@response.body)
  results = JsonPath.new(json_path).on(json)
  if self.respond_to?(:expect)
    expect(results.length).to eq(length.to_i)
  else
    assert_equal length.to_i, results.length
  end
end

def basic_authorize(username, password)
  encoded_login = ["#{username}:#{password}"].pack('m0')
  header('Authorization', "Basic #{encoded_login}")
end

def header(name, value)
  if value.nil?
    @headers.delete(name)
  else
    @headers[name] = value
  end
end