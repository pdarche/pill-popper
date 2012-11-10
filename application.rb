require 'bundler'
Bundler.require

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite")

class Thing
  include DataMapper::Resource
  
  property :id, Serial, :key => true
  property :title, String
  property :description, Text
end

DataMapper.finalize

get '/' do
  erb :index
end

get '/things' do
  @things = Thing.all
  erb :things_index
end

get '/things/new' do
  erb :things_new
end

post '/things' do
  @thing = Thing.new(params)
  @thing.save
  redirect '/things'
end

get '/things/:id' do
  @thing = Thing.get(params[:id])
  erb :things_show
end

get '/things/:id/edit' do
  @thing = Thing.get(params[:id])
  erb :things_edit
end

post '/things/:id' do
  @thing = Thing.get(params[:id])
  @thing.update(:title => params[:title], :description => params[:description])
  @thing.save
  redirect "/things/#{params[:id]}"
end

get '/things/:id/delete' do
  Thing.get(params[:id]).destroy
  redirect '/things'
end
