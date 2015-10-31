class TidyFormBuilder < ActionView::Helpers::FormBuilder
	# To save repeating ourselves in many contexts, we can create
  # our own helper for picking countries.

  # We might want to write:
  # <div class="field">
  # 	<p>
  # 	<%= f.label :country %><br />
  #    <%= f.country_select :country %>
  #  </p>
  # </div>
  #
  # our country_select just calls the default select helper with the
  # choices already filled in
  def country_select(method, options={}, html_options={})
    select(method, [['Canada', 'Canada'],
                     ['Mexico', 'Mexico'],
                     ['United Kingdom', 'UK'],
                     ['United States of America', 'USA']],
                  options, html_options)
  end
end