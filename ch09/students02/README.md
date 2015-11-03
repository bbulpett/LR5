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