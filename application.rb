require 'bundler'
Bundler.require

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite")

class User
  include DataMapper::Resource
  
  property :id, Serial, :key => true
  property :name, String
  property :age, Integer
  property :description, Text
  property :pharmacist, Text
  property :doctor, Text

  has n, :prescriptions

end

class Prescription
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :medication, Text
  property :condition, Text
  property :start_date, Date
  property :end_date, Date
  property :prescribed_by, Text
  property :regimen, Text

end

class Pharmacist
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :name, Text
  property :pharmacy, Text 

  has n, :users

end

DataMapper.finalize

get '/' do
  erb :index
  @users = Users.all
  @title = 'Pill Popper'
  @js = 'index'
  @style = 'index'
end

put '/take_med' do
  #set prescription to taken for date

end

get '/pharmacist/:id' do
  erb :pharmacist
  @title = 'Pharmacists'
  @js = 'pharmacist'
  @style = 'pharmacist'
  @patients = Users.all(:pharmacist => params[:id]) #this'll need to change.  filter by pharmacist name / (id?)
end

post '/add_prescription' do
  @prescription = Prescription.new(params)
  @prescription.save
  redirect '/pharmacist'
end

