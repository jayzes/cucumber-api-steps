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

      if request.accept.include? 'application/xml'
        books.to_xml
      else
        books.to_json
      end
    end

    post '/api/books' do
      status 201 if params.values == ["Metaprograming ruby", "Pragprog"]
    end

    post '/api/publishers' do
      input_data = JSON.parse request.env["rack.input"].read, symbolize_names: true
      status 201 if input_data == {publisher: 'Pragprog'}
    end
  end
end
