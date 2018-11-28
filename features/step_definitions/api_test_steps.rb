require 'active_support'
require 'active_support/core_ext'

Given /^I define instance variable (@[\w]+) = (.*)$/ do |name, value|
  instance_variable_set(name, eval(value))
end

When /^I perform the following steps?:$/ do |step_strings|
  steps = step_strings.split("\n")
  steps.each {|step_string| step step_string }
end

When /^I perform the following steps which may raise ([\w]+)?:$/ do |exception_name, step_strings|
  exception_type = exception_name.constantize
  steps = step_strings.split("\n")
  steps.each do |step_string|
    begin
      step step_string
    rescue exception_type => ex
      @last_exception = ex
    end
  end
end

Then /^([\w]+) was raised$/ do |exception_name|
  exception_type = exception_name.constantize
  @last_exception.should be_an_instance_of(exception_type)
end

Then /^the response should equal:$/ do |response_body|
  expect(last_response.body).to eq(response_body)
end

When /^I perform the following step with table:$/ do |step_definition|
  lines = step_definition.split("\n")
  step_string = lines.shift

  raw = lines.map do |line|
    line.squish.gsub(/^\|/, '').gsub(/\|$/, '').squish.split("|").map(&:squish)
  end

  step step_string, table(raw)
end

When /^I perform the following step with string:$/ do |step_definition|
  lines = step_definition.split("\n")
  step_string = lines.shift

  param_string = lines.join("\n")

  step step_string, param_string
end

Then /^the request headers should be:$/ do |headers|
  headers_hash = headers.rows_hash
  request '/'
  expect(last_request.env.slice(*headers_hash.keys).values).to eq(headers_hash.values)
end

Then /^I should be authenticated$/ do
  expect(last_request.env["HTTP_AUTHORIZATION"]).to eq("Basic #{Base64.strict_encode64("joe:god")}")
end

Then /^I should be digest authenticated$/ do
  expect(last_request.env["HTTP_AUTHORIZATION"].starts_with?("Digest ")).to be true
end
