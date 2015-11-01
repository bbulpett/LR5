#LR5
##Chapter 8
###"Improving Forms"

This chapter builds on the "Guestbook" application by adding support for file uploads. In addition, form builders will be added to aid in the creation of custom forms.

To begin, open last app from Chapter 7 (guestbook06) in the text editor.

<sub>Alternatively, a new app can be created (i.e. "guestbook07") that is identical to _ch07/guestbook06_.</sub>

####"Adding a Picture by Uploading a File"
#####"File Upload Forms"

In the text editor, open the **people** form in app/views/people/_form.html.erb and add the following block of code:

		<div class="field">
			<%= f.label :photo %><br>
			<%= f.file_field :photo %>
		</div>

Since the form is now a "multipart" form, accepting attachment files along with post data, the form tag (at line 1 of the file) needs to reflect these changes. Modify the **form_for** method to read like this:

		<%= form_for(@person, :html => { :multipart => true }) do |f| %>

Remember to save the updated form before proceeding.

#####"Model and Migration Changes"
**A migration for an extension**

In the terminal, ensure that the prompt is at the current app (i.e. "guestbook") directory and run the following command:

		rails generate migration add_photo_extension_to_person

Locate the migration that was just created in the _db/migrate_ directory. Add the following line of code to the _change_ method:

		def change
			add_column :people, :extension, :string
		end

Run `rake db:migrate` to add the new column to the **:people** table.

**Strong parameters, again**

The migration has added the extension as a column in the database, however the information is still coming to the application as **:photo**. This means that **:photo** needs to be "whitelisted" in the private **person_params** method (at the end of *app/controllers/people_controller.rb*. The updated **person_params** method should look like this:

		# Never trust parameters from the scary internet, only allow the white list through.
		def person_params
			params.require(:person).permit(:name, :secret, :country,
				:email, :description, :can_send_email, 
				:graduation_year, :body_temperature, :price,
				:birthday, :favorite_time, :photo)
		end

**Extending a model beyond the database**

To begin building the process by which photo files will actually be stored, open *app/models/person.rb* in the text editor. Create some whitespace before the closing (last) **end** statement and add the following method that will ensure the form data will be validated *before* attempting to store the photo:

		# callback method to store photo after validation
		after_save :store_photo

This callback references the **store_photo** method, which may be entered next. To ensure that this method can only be called from *within* this model class, use the **private** keyword just before defining the method like this..

		private
  
		# called after saving, to write the uploaded image to the filesystem
		def store_photo
			if @file_data
				# make the photo_store directory if it doesn't exist already
				FileUtils.mkdir_p PHOTO_STORE
				# write out the image data to the file
				File.open(photo_filename, 'wb') do |f|
					f.write(@file_data.read)
				end
				# avoid repeat-saving
				@file_data = nil
			end
		end

Next, add the method that will actually add the input from the form's file_field and write that data to the **person** model's **:photo** attribute (i.e. person.photo). 
Add the following method just after the **:store_photo** callback method above, paying attention to the special syntax of the _assignment method_:

		# when photo data is assigned via the upload, store the file data
		# for later and assign the file extension, e.g. ".jpg"
		def photo=(file_data)
			unless file_data.blank?
				# store the uploaded data into a private instance variable
				@file_data = file_data
				# figure out the last part of the file name and use this as
				# the file extension. e.g. from "me.jpg" will return "jpg"
				self.extension = file_data.original_filename.split('.').last.downcase
			end
		end

After the **photo=** assignment method, define a path for the image files to be stored. Add the following line:

		PHOTO_STORE = File.join Rails.root, 'public', 'photo_store'

NOTE: File.join is a cross-platform way of joining directories. Alternatively, we could have written "#{Rails.root}/public/photo_store".

The following method uses this new path and generates a filename based on the **Person** id associated with the photo, concatenated with the file extension:

		def photo_filename
			File.join PHOTO_STORE, "#{id}.#{extension}"
		end

The next method creates a reference to the path of the photo which may be used as a URL in the view.

		def photo_path
			"/photo_store/*{id}.#{extension}"
		end

Finally, a method to verify that a photo actually exists. This will eliminate "broken" image links in the view.

		def has_photo?
			File.exists? photo_filename
		end

**Showing It Off**

In the text editor, open *app/views/people/show.html.erb* and add the following code just before the `<%= link_to %>` statements at the end:

		<p>
			<strong>Photo:</strong>
				<% if @person.has_photo? %>
					<%= image_tag @person.photo_path %>
				<% else %>
					No photo.
				<% end %>
		</p>

#####"Results"

Start the rails server (`rails s`) and navigate in the browser to _localhost:3000/people_. Use the form to create a new **Person** model with a photo attached. Once created, the model will be available on the index page. Select the **Show** link to view the updated **Person** display, as created in the previous section ("Showing It Off").

###"Standardizing Your Look with Form Builders"

To begin open last app from the last exercise, "Adding a Picture by Uploading a File" (guestbook07), in the text editor.

<sub>Alternatively, a new app can be created (i.e. "guestbook08") that is identical to _ch08/guestbook07_.</sub>

####"Supporting Your Own Field Types"

Endeavoring to keep the application's forms closely associated with its models, create a form helper that accepts more specific types of data. The application uses the *button_select* helper method created in Chapter 6. Create a new file in *app/helpers* called `tidy_form_builder.rb`, which will contain the following code:

		class TidyFormBuilder < ActionView::Helpers::FormBuilder
			def country_select(method, options={}, html_options={})
				select(method, [['Canada', 'Canada'],
				['Mexico', 'Mexico'],
				['United Kingdom', 'UK'],
				['United States of America', 'USA']],
				options, html_options)
			end
		end

Whereas helper classes are available to the app's views by name, *builders* need to be called **explicitly**. To call *TidyFormBuilder* in the Person form, add it as the **:builder** parameter in the *form_for* method (app/views/people/_form.html.erb):

		<%= form_for(@person, :html => { :multipart => true }, :builder => TidyFormBuilder) do |f| %>

Now, replace the _entire_ `<div>` in the form that pertains to the **:country** field, with the following "tidier" block that uses the **country_select** method as defined in the TidyFormBuilder:

		<div class="field">
			<%= f.label :country %><br>
			<%= f.country_select :country %>
		</div>
		 
Opening the form in the browser shows that the dropdown menu for the **:country** field works the same as it did before. However, the code is now much more efficient and specific.

####"Adding Automation"

To begin open last exercise, "Standardizing Your Look with Form Builders" (guestbook08), in the text editor.

<sub>Alternatively, a new app can be created (i.e. "guestbook09") that is identical to _ch08/guestbook08_.</sub>

Returning to the text editor, open *app/helpers/tidy_form_builder.rb*. After the `country_select` method, add the following method. It will eliminate the need for `f.label` for text fields in the form view:

		def text_field(method, options={})
			label_for(method, options) + super(method, options)
		end

The **method** and **options={}** parameters are straight out of the Rails API documentation. These parameters will vary for other field types.
For this to work, we must also add the **label_for** method at the end of the _TidyFormBuilder_ class. It is a "private" method, meaning it may only be used within the model class.

		private

		def label_for(method, optoins={})
			label(options.delete(:label) || method).safe_concat("<br />")
		end

Now, back in *app/views/people/_form.html.erb*, we can eliminate the `f.label` code from all of the text fields. They will simply be..

		<div class="field">
			<%= f.text_field :name %>
		</div>
		
		...

		<div class="field">
			<%= f.text_field :email %>
		</div>
		
		...

		<div class="field">
			<%= f.text_field :body_temperature %>
		</div>

		...

		<div class="field">
			<%= f.text_field :price %>
		</div>

Similarly, we must now add methods for the other field types. Again, the parameters are derived from the Rails API documentation. These are not "private" methods and should be entered just after the `text_field` definition.

		def text_area(method, options={})
			label_for(method, options) + super(method, options)
		end
 
		def password_field(method, options={})
			label_for(method, options) + super(method, options)
		end
   
		def file_field(method, options={})
			label_for(method, options) + super(method, options)
		end

Other helpers are slightly more complex..

		def date_select(method, options = {}, html_options = {})
			label_for(method, options) + super(method, options, html_options)
		end

		def select(method, choices, options = {}, html_options = {})
			label_for(method, options) + super(method, choices, options, html_options)
		end

		def time_select(method, options = {}, html_options = {})
			label_for(method, options) + super(method, options, html_options)
		end

		def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
			label_for(method, options) + super(method, options, checked_value, unchecked_value)
		end

Once these helper methods have been added to the _TidyFormBuilder_, it is possible to remove the respective `f.label` code from the "people" form partial.	The form code is now much more efficient, legible, and flexible.	
