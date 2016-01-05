class EntriesController < ApplicationController

			def sign_in
				#get names array from session
				@names=session[:names]

				#if the array doesn't exist, make one
				unless @names
					@names=[]
				end

				#get the latest name from the form
				@name = params[:visitorName]

				if @name
					# add the new name to the names array
					@names << @name
				end

				# store the new names array in the session
				session[:names]=@names
			end
			
end
