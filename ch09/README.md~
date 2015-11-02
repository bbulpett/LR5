#LR5

##Chapter 9
###"Developing Model Relationships"

Chapter 9 deals with apps that have multiple tables and how to connect and relate them to one another.

####"Connecting Awards to Students"

At the terminal prompt, create a new rails application:

		rails new students01

Change to the app directory (`cd students01`) and run the following command to create a **student** model with its basic attributes..

		rails generate scaffold student given_name:string middle_name:string family_name:string date_of_birth:date grade_point_average:decimal start_date:date

Now create an additional model with scaffolding..

		rails generate scaffold award name:string year:integer student_id:integer

Notice that we've given the **award** model a "student_id" attribute. This will be used as a foreign key to connect to the **student** model.

####"Establishing the Relationship"

Next, the relationships must be defined in the application's models. In the text editor, open *app/models/student.rb* and insert the following declaration between the `class` and `end` lines:

		has_many :awards

Similarly, the following line must be added to *app/models/award.rb*:

		belongs_to :student

At the terminal, run `rake db:migrate`. The two models are now connected in a very basic *one-to-many* relationship. Starting the Rails server (`rails s`) and navigating to *localhost:3000/students/new*, create a new **student** record.

####"Supporting the Relationship"


