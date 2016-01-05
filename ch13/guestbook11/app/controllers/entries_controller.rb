class EntriesController < ApplicationController

	def sign_in
		@previous_name = cookies[:name]
		@name = params[:visitor_name] # Held over from the original controller
		cookies[:name] = @name

		### Below is the logic that was used in the original controller 
		#  unless @name.blank?
		#  		@entry = Entry.create({:name => @name})
		#  end
		#  @entries = Entry.all
	end
end
