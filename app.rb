require 'sinatra'
require 'sinatra/json'
require 'sinatra/cors'
require 'sequel'

set :allow_origin, "*"

DB = Sequel.connect('sqlite://api.db')

Sequel::Model.plugin :json_serializer
Sequel::Plugins::JsonSerializer.configure(Sequel::Model, naked: true)

DB.create_table? :tasks do
  primary_key :id
  String :title
  String :description
  Boolean :completed, default: false
end

class Task < Sequel::Model
end

configure do
  enable :cross_origin
end

before do
  content_type :json
end

get '/' do
  json({say: 'hi'})
end

get '/auth' do
  json({isAuth: true})
end

get '/tasks' do
  tasks = Task.all
  tasks.to_json
end

post '/tasks' do
  data = JSON.parse(request.body.read)
  task = Task.create(title: data['title'], description: data['description'])
  task.to_json 
end
