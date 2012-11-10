# This is the file that Heroku uses to launch Sinatra applications. So this
# file needs to know about all the code from the other files that make up
# the applicaton. Since we made `application.rb` reference all other files,
# loading that file will bring the rest of the code.
require './application'
# Note the "./" before the file name are required for Ruby 1.9.X.
# Also, when loading .rb files the extension can be omitted.

# Now that all the code has been loaded, tell Heroku to run the code as a
# Sinatra application
run Sinatra::Application
