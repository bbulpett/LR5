class EntriesController < ApplicationController

	def sign_in
		@name = params[:visitor_name]
	end
	
end
