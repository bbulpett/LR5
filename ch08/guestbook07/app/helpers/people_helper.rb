module PeopleHelper
	def button_select(model_name, target_property, button_source)
		html=''
		list = button_source.sort

		if list.length < 4
			html << '<fieldset><legend>Country</legend>'
			list.each {|x|
				html << radio_button(model_name, target_property, x[1])
				html << (x[0])
				html << '<br>'
			}
			html << '</fieldset>'
		else
			html << ' <label for="person_country">Country</label><br>'
			html << select(model_name, target_property, list)
		end
		return html.html_safe
	end

end
