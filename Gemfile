# Tells Bundler where to look for gems
source :rubygems

gem 'sinatra'

# This is the core gem for DataMapper which we use to talk to the database.
gem 'data_mapper'

# When developing an app locally you can use SQLite which is a relational
# database stored in a file. It's easy to set up and just fine for most
# development situations.
group :development do
  gem 'dm-sqlite-adapter'
end

# Heroku uses Postgres however, so we tell the Gemfile to use Postgres
# in production instead of SQLite.
group :production do
  gem 'dm-postgres-adapter'
end
