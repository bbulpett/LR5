#LR5

##Chapter 9
###"Nesting Awards in Students"

This section builds on the "student01" application by altering routing and controller logic to create nested resources and further define the actual roles of the app's models.

To begin, open the app from the previous section (student01) in the text editor.

<sub>Alternatively, a new app can be created (i.e. "student02") that is identical to _ch09/student01_.</sub>

####"Changing the Routing"

In the text editor, open *config/routes.rb* and replace the following lines:

		resources :awards
		resources :students

With this code, which declares a nested resource relationship:

		resources :students do
			resources :awards
		end

By capturing this relationship in the app's routing, it has also creates routing helpers. For instance, the path for the **awards#new** controller action has gone from `new_award` to `new_student_award`. Running `rake routes` in the console presents all of the new routing patterns.

####"Changing the Controller"

Now that routing patterns have been created that properly relate students and awards, changes to *app/controllers/awards_controller.rb* must be made to provide the context that limits awards to a specific student.

To begin, add the following line just after the class declaration at the top of the file:

		before_action :get_student

This is a filter which references the **:get_student** method, which needs to be created at the end of the file after the **private** keyword..

		private
		
		def get_student
			@student = Student.find(params[:student_id])
		end

Now that the _@student_ instance variable is created, it can be referenced in the controller's other methods. In the **index** method, replace `@awards = Award.all` with the following line of code:

		@awards = @student.awards

In the **show** method, add the following line:

		@award = @student.awards.find(params[:id])

In the **new** method, change the `@award = Award.new` line to this:

		@award = @student.awards.build

In the **edit** method, insert the following line:

		@award = @student.awards.find(params[:id])

In the **create** method, change `@award = Award.new(award_params)` to:

		@award = @student.awards.build(award_params)

Add the following line of code to the top of the **update** method:

		@award = @student.awards.find(params[:id])

In both the **create** and **update** methods, change the *format.html* line of the **if** conditional in the *respond_to* block to this:

		format.html { redirect_to student_awards_url(@student), notice: 'Award was successfully created.' }
		# Of course, use the term "updated" for the update method notice.

Lastly, in the **destroy** method, just before `@award.destroy`, enter:

		@award = @student.awards.find(params[:id])

and change the html path in the *respond_to* block from `redirect_to awards_url` to this..

		format.html { student_awards_path(@student), notice: 'Award was successfully destroyed.' }

Save the file. However, an attempt to navigate to the awards pages as before will yield some odd results. The next section will modify the views to reflect the changes made to the controller.

####"Changing the Award Views"

Open *app/views/awards/index.html.erb* in the text editor and change the heading to reflect the student whose awards are being shown..

		<h1>Awards for <%= @student.name %></h1>

Next, the awards table must be wrapped in a conditional block. Start by adding the following **if** statement just before the `<table>` tag:

		<% if !@student.awards.empty? %>

After the closing `</table>` tag, finish the conditional statement with the following code:

		<% else %>
			<p><%= @student.given_name %> hasn't won any awards yet.</p>
		<% end %>

The `link_to` statements also need to specify the student model:

		`<td><%= link_to 'Show', [ @student, award ] %></td>`
          	`<td><%= link_to 'Edit', edit_student_award_path( @student, award ) %></td>`
          	`td><%= link_to 'Destroy', [ @student, award ], method: :delete, data: { confirm: 'Are you sure?' } %></td>`
		
		<%= link_to 'New Award', new_student_award_path(@student) %>

Also, add a link to help users navigate "back"..

		<%= link_to 'Back', @student %>

In *app/views/awards/show.html.erb*, change the `link_to` statements in similar fashion:

		<%= link_to 'Edit', edit_student_award_path(@student, @award) %>
		<%= link_to 'Back', student_awards_path(@student) %>

Both *app/views/awards/new.html.erb* and *app/views/awards/edit.html.erb* need their headings changed as follows, respectively..

		<h1>New Award for <%= @student.name%></h1>

and

		<h1>Editing Award for <%= @student.name %></h1>

Similar to the other views, the `link_to` statements at the bottom of the **new** and **edit** views need to change.

Perhaps most importantly, *app/views/_form.html.erb* needs to reference the **student** model as well. Change the `form_for` call at the first line to read as follows:

		<%= form_for([ @student, award ]) do |f| %>

Also, the field `<div` for the **student_id** attribute must also be removed. The award will only pertain to the current **student**. Remove the following block of code:

		<div class="field">
			<%= f.label :student_id %><br>
			<%= f.select :student_id, Student.all.collect {|s| [s.name, s.id]} %>
		</div>

Finally, in *app/controllers/awards_controller*, the `@award = @student.awards.find(params[:id])` lines are no longer needed in the **show**, **edit**, **update** and **destroy** methods. Delete the lines from those methods. Then scroll down to the "private" section and change the **set_award** method to specify that awards will pertain to the current **student** model...

		def set_award
			@award = @student.awards.find(params[:id])
		end

####"Connecting the Student Views"

To make it more convenient to access the student's award views, add a link to *app/views/students/show.html.erb*, just between the **Edit** and **Back** links (at the bottom of the file):

		<%= link_to 'Awards', student_awards_path(@student) %>

Also, a link should be added to *app/views/students/index.html.erb*, as a table cell - between the links to the **Edit** and **Destroy**...

		<td><%= link_to 'Awards', student_awards_path(student) %></td>

Lastly, when adding a table cell in this manner, the `colspan` attribute of the final `<th` tag (inside the `<thead></thead>` markup block) needs to be changed from "3" to "4".

