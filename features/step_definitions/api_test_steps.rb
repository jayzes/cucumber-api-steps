require 'active_support/core_ext'

When /^I perform the following step:$/ do |step_string|
  step step_string
end

Then /^the response should equal:$/ do |response_body|
  last_response.body.should eq(response_body)
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
  last_request.env.slice(*headers_hash.keys).values.should eq(headers_hash.values)
end
