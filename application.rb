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
  property :affiliation,  Text
  
  has n, :prescriptions

end


class Prescription
  include DataMapper::Resource

  property :id,            Serial, :key => true
  property :prescribed_by, Text
  property :number,        Integer
  property :hours,         Integer
  property :medication,    Text
  property :condition,     Text
  property :basic_info,    Text
  property :side_effects,  Text
  property :warnings,      Text

  belongs_to :user

end

class Pills_Taken
  include DataMapper::Resource

  property :id,             Serial, :key => true
  property :userId,         Integer
  property :medId,          Integer
  property :time_scheduled, DateTime
  property :time_taken,     DateTime
  property :taken,          Boolean

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
  users = []
  @user = User.first(:username => params[:username])
  
  unless @user.affiliation == nil
    @affiliate = User.first(:username => @user.affiliation)  
  end

  @title = 'Pill Popper'
  @js = 'home'
  @style = 'home'
  erb :home
end

post '/take_med' do
  taken = Pills_Taken.new()
  taken.userId = params[:userId]
  taken.medId = params[:medId]
  taken.taken = params[:taken]
  taken.time_scheduled = Time.now
  taken.time_taken = Time.now

  if taken.save
    p "success"
  else 
    p "you f'd up"
  end

end

get '/check_meds' do
  username = session[:username]
  user = User.first(:username => username)
  affiliate = User.first(:username => user.affiliation)

  userId = user.id
  affiliateId = affiliate.id

  userPre = user.prescriptions
  affiliatePre = affiliate.prescriptions

  # p prescriptions[0].medication

  finalHash = Hash.new

  user_taken = Pills_Taken.all(:userId => userId)
  userTaken = []

  if user_taken != nil
    userPre.each do | prescription | 
      last = Pills_Taken.last(:medId => prescription.id) 
      last.time_taken = last.time_taken.to_time.to_i
      userTaken << last.to_json
    end
  end

  affil_taken = Pills_Taken.all(:userId => userId)
  affilTaken = []

  if affil_taken != nil
    affiliatePre.each do | prescription | 
      last = Pills_Taken.last(:medId => prescription.id) 
      last.time_taken = last.time_taken.to_time.to_i
      affilTaken << last.to_json
    end
  end

  finalHash["user"] = userTaken
  finalHash["affiliate"] = affilTaken 

  finalHash.to_json

end

post '/add_prescription' do
  user = User.first(:username => params[:username])
  prescription = Prescription.new()
  prescription.prescribed_by = params[:prescribed_by]
  prescription.medication = params[:medication]
  prescription.number = params[:number]
  prescription.hours = params[:hours]
  prescription.condition = params[:condition]
  prescription.basic_info = params[:basic_info]
  prescription.side_effects = params[:side_effects]
  prescription.warnings = params[:warnings]

  # p user
  user.prescriptions << prescription

  if user.save && prescription.save
    redirect '/home/' + user.username
  else
    p "fucked up"
  end
end

get '/new_prescription/:username' do 
  @user = params[:username]
  @js = 'add_prescription'
  @style = 'datepicker'
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



