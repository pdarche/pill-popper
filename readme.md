# Pill Poppin'
**A little Sinatra app made by Ben Light and Peter 'Ate The Whole Thing' Darche to disrupt the hell out of the pharmaceutical indsutry**

## Usage

1. Download.
2. In Terminal navigate to the folder and run the following command:

        $ bundle install --without production
3. Migrate the database:

        $ irb
        >> require './application'
        >> DataMapper.auto_migrate!
        
4. Launch the application

        $ rackup

5. You should then be able to view the site at http://localhost:9292/
