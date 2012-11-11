require 'bundler'
Bundler.require

require './helpers/partials'

# helpers Sinatra::partials


DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite")

class User
  include DataMapper::Resource
  
  property :id,           Serial, :key => true
  property :username,     Text
  property :password,     Text
  property :name,         String
  property :age,          Integer
  property :description,  Text
  property :pharmacist,   Text
  property :affiliation,  Integer

  has n, :prescriptions

end


class Prescription
  include DataMapper::Resource

  property :id,            Serial, :key => true
  property :medication,    Text
  property :condition,     Text
  property :start_date,    Date
  property :end_date,      Date
  property :prescribed_by, Text
  property :regimen,       Text

end


class Pharmacist
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :name, Text
  property :pharmacy, Text 

  has n, :users

end

DataMapper.finalize


##### LANDINGPAGE, LOGIN, SIGNUP
get '/' do
  @js = 'index'
  @style = 'index'
  erb :index
end

post '/signup' do
  @user = User.new(params)
  if @user.save
     puts "did it"
     redirect('/')
  end
end

post '/login' do
  @user = User.get(:username => params[:username])
  id = @user.id.to_i
  redirect '/home/#{id}' 
end


##### USER FUNCTIONALITY 

get '/home/:id' do
  @user = User.get(params[:id])
  @title = 'Pill Popper'
  @js = 'home'
  @style = 'home'
  erb :home
end

put '/take_med' do
  #set prescription to taken for date

end


##### PHARMACIST FUNCTIONALITY

get '/pharmacist' do
  @title = 'Pharmacists'
  @js = 'pharmacist'
  @style = 'pharmacist'
  erb :pharmacist
  # @patients = Users.all(:pharmacist => params[:id]) #this'll need to change.  filter by pharmacist name / (id?)
end

post '/add_prescription' do
  @prescription = Prescription.new(params)
  @prescription.save
  redirect '/pharmacist'
end



