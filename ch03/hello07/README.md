#LR5

_The following steps were used to recreate the Learning Rails 3 files within Ruby on Rails version 5.0.0.beta1. Development environment Ruby 2.2.2 and Rails 5.0.0.beta1 on Ubuntu Linux version 14.04._

## Chapter 3

#### "Sharing Template Data with the Layout (hello07)"
(open app/views/hello/index.html.erb) Add the following HTML structure below the existing code:

	<% content_for(:list) do %>
		<ol>
			<% for i in 1 ..@count %>
			<li><%= @bonus %></li>
			<% end %>
		</ol>
	<% end %>

(open app/layouts/hello.html.erb) Add the statement `<%= yield :list %>` to the area just below the `<body>` tag so that the body contents read as follows:

	<body>
	<%= yield :list %>
	<!-- layout will incorporate view -->
	<%= yield %>
	</body>

Save the file and refresh the browser to see the ordered list of the bonus message at the top of the viewport.

## IMPORTANT NOTE:
"Setting a Default Page" has been intentionally omitted. The default page has already been set in Chapter 1 (hello01), where the line `root 'hello#index'` defined the default page (root) of the site. Rails 5 no longer uses the syntax _`root :to => "hello#index"`_.

***
<sup>Tested and reconciled with changes made to book text</sup>
