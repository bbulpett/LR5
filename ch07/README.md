#LR5
##Chapter 7
###"Strengthening Models with Validation"

Validation is a way to ensure that only appropriate data is stored in the application's database. Although _client-side_ validations can easily be done with HTML5 or javascript, this approach is less secure than the _server-side_ validations that we will now add to our Rails models.

To begin, open last app from Chapter 6 (guestbook04) in the text editor.

<sub>Alternatively, a new app can be created (i.e. "guestbook05") that is identical to _ch06/guestbook04_.</sub>
####"The Original Model"

As we first discussed in chapter 4 (_ch04/guestbook02_), the attributes for models we create are defined (as "required" or "permitted") in the associated controller. Therefore, in **app/models/person.rb** we find an empty model declaration that looks like this:

		class Person < ActiveRecord::Base
		end

However, in **app/controllers/people_controller.rb**, we find the following method appended to the end of the file:

		# Never trust parameters from the scary internet, only allow the white list through.
	    	def person_params
	      		params.require(:person).permit
			(:name, :secret, :country, :email, :description, :can_send_email, :graduation_year, :body_temperature, :price, :birthday, :favorite_time)
	    	end

Having these attributes abstracted to the controller enhances the security of our data and provides a clean slate to work with the model itself.
	
####"The Power of Declarative Validation (guestbook05)"

In the text editor, open _app/models/person.rb_. Create a little whitespace between the `class Person...` line and the `end` statement. Add the following line of code to mandate the inclusion of the "name" attribute when creating a new **Person** model:

		validates_presence_of :name

Save the file, then navigate to _localhost:3000/people_ in the browser. Click the "New Person" link to bring up the form. Fill out the form, but **leave the "name" field blank**. When the _Create Person_ button is clicked, the transaction begins, but is unsuccessful. Rails immediately "rolls back" the transaction and issues an error, "Name can't be blank", which comes from `<div id="error_explanation">` in the _app/views/people/\_form_ partial. 

####"Managing Secrets"

The **:secret** field is a good place to demonstrate multiple validations.

######"Customizing the Message"

In the text editor, open _app/models/person.rb_. Just after the new validation for the presence of the _:name_ field, add the following line to provide a "friendly" error message should the **:secret** field be left blank:
		
		# make the secret mandatory and provide a customized message
		validates_presence_of :secret, 
			:message => "must be provided so we can recognize you in the future"

Add the following validations to test the actual _content_ of the **:secret** entry.

		# ensure secret has enough letters, but not too many
		validates_length_of :secret, :in => 6..24

		# ensure secret contains at least one number
		validates_format_of :secret, :with => /[0-9]/,
			:message => "must contain at least one number"

		# ensure secret contains at least one upper case letter
		validates_format_of :secret, :with => /[A-Z]/,
			:message => "must contain at least one upper case character"

		# ensure secret contains at least one lower case letter
		validates_format_of :secret, :with => /[a-z]/,
			:message => "must contain at least one lower case character"

Save the changes to _person.rb_ and restart the Rails server. As before, navigate to the "New Person" form in the browser and fill in the form. Test the above validations in the "secret" field. Notice that leaving the field empty will trigger _all_ of the validation messages upon submitting the form.



