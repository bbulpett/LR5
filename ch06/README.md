#LR5

##Chapter 6:

####"Presenting Models with Forms"

At the terminal, run the following command to create a new application:

	rails new guestbook

Enter the following to create scaffolding for the app with a basic data structure:

	rails generate scaffold Person name:string secret:string country:string email:string description:text can_send_email:boolean graduation_year:integer body_temperature:float price:decimal birthday:date favorite_time:time

Now run `rake db:migrate` to implement the migration created with the scaffold generator.
