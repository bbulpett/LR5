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
