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

	

