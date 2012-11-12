require 'bundler'
Bundler.require

require './helpers/partials'

# helpers Sinatra::partials

DataMapper.setup(:default, "sqlite://#{Dir.pwd}/test.db")

class User
  include DataMapper::Resource
  
  property :id,           Serial, :key => true
  property :username,     Text
  property :password,     Text
  property :name,         String
  property :age,          Integer
  
  has n, :prescriptions

end


class Prescription
  include DataMapper::Resource

  property :id,            Serial, :key => true
  property :medication,    Text
  property :condition,     Text
  property :start_date,    Text
  property :end_date,      Text
  property :prescribed_by, Text
  property :regimen,       Integer
  property :take,          Integer
  property :basic_info,    Text
  property :side_effects,  Text
  property :warnings,      Text

  belongs_to :user

end

class Pills_Taken
  include DataMapper::Resource

  property :id,            Serial, :key => true
  property :userId,        Integer
  property :medId,         Integer
  property :taken,         Boolean

end

DataMapper.finalize


enable :sessions

##### LANDINGPAGE, LOGIN, SIGNUP
get '/' do
  @js = 'index'
  @style = 'index'
  erb :index
end

post '/signup' do
  user = User.new(params)

  if user.save
     p "did it"
     redirect('/home/' + user.username)
  else
     redirect('/')
     p "you fucked up"
  end
end

post '/login' do
  if params[:username] != nil && params[:password] != nil
    user = User.first(:username => params[:username], :password => params[:password])
    
    if user == nil
      redirect('/')
    else
      username = user.username
      session[:username] = username
      redirect '/home/' + username
    end
  else
    p params[:username].type
    redirect('/')
  end
end


##### USER FUNCTIONALITY 

get '/home/:username' do
  unless session[:username] == params[:username]
    redirect('/')
  end

  @user = User.first(:username => params[:username])  
  @title = 'Pill Popper'
  @js = 'home'
  @style = 'home'
  erb :home
end

put '/take_med' do
  #set prescription to taken for date

end

post '/add_prescription' do
  user = User.first(:username => params[:username])
  prescription = Prescription.new()
  prescription.medication = params[:medication]
  prescription.condition = params[:condition]
  prescription.start_date = params[:start_date]
  prescription.end_date = params[:end_date]
  prescription.prescribed_by = params[:prescribed_by]
  prescription.regimen = params[:regimen]
  prescription.take = params[:take]
  prescription.basic_info = params[:basic_info]
  prescription.warnings = params[:warnings]

  p user
  user.prescriptions << prescription

  if user.save && prescription.save
    redirect '/home/' + user.username
  else
    p "fucked up"
  end
end

get '/new_prescription/:username' do 
  @user = params[:username]
  erb :add_prescription
end

##### PHARMACIST FUNCTIONALITY

get '/pharmacist' do
  @title = 'Pharmacists'
  @js = 'pharmacist'
  @style = 'pharmacist'
  erb :pharmacist
  # @patients = Users.all(:pharmacist => params[:id]) #this'll need to change.  filter by pharmacist name / (id?)
end



