require "rubygems"
require "sinatra/base"

module CucumberApiSteps
  class FakeApp < Sinatra::Base

    get '/' do end

    get '/api/books' do
      books = {books: [
        {title: 'Pride and prejudice'},
        {title: 'Metaprograming ruby'}
      ]}

      if request.accept.empty? || request.accept?('application/json')
        content_type :json
        books.to_json
      elsif request.accept?('application/xml')
        content_type :xml
        books.to_xml
      end
    end

    post '/api/books' do
      status 201 if params.values == ["Metaprograming ruby", "Pragprog"]
    end

    patch '/api/books' do
      status 200 if params.values == ["Metaprograming ruby", "Pragprog"]
    end

    post '/api/publishers' do
      input_data = JSON.parse request.env["rack.input"].read, symbolize_names: true
      status 201 if input_data == {publisher: 'Pragprog'}
    end
  end
end
