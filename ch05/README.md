##LR5

##Chapter 5:

####"A First Look at Scaffolding"

Run the following command at the terminal: `rails new guestbook03`

Navigate to the new project directory: `cd guestbook03`

Run the following command to creat a model with supporting scaffolding:

	rails generate scaffold Person name:string

Run `rake db:migrate` and start the server: `rails server`. This will show the generic Rails "welcome" page. Instead, we want the application to open at the index page for the _People_ model that was just created by the scaffold generator. Open guestbook03/config/routes.rb and look for the following line (around line 7):

	# root 'welcome#index'

Remove the "#" sign from this line of code and change it to read like this:

	root 'people#index'

Save the changes to the file and restart the server with `rails server`. Refreshing the browser will now show the index page for the _People_ model. Click the "New Person" link to reach the "New Person" page. Enter a name and click the "Create" button. 

NOTE: The scaffolding has added a Person model represented by the _person.rb_ file. However, this model is empty. Older versions of Rails would have inserted a line reading `attr_accessible :name` to define what model attributes the application could access. Instead, this application has created *strong parameters* in *people_controller.rb*. A private method at the end of the controller reads as follows:

	def person_params
	    params.require(:person).permit(:name)
	end	

This method achieves the same as the one added to the *guestbook02* app in chapter 4. Scaffolding has created this for us automatically.


