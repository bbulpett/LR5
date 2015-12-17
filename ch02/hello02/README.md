# LR5

_The following steps were used to recreate the Learning Rails 3 files within Ruby on Rails version 5.0.0.alpha. Development environment Ruby 2.2.2 and Rails 5.0.0.alpha on Ubuntu Linux version 14.04._

## Chapter 2

####"Adding Some Data (hello02)"
(app/controllers/hello_controller) Change the index method to read as follows:

    class HelloController < ApplicationController
      def index
      	@message="Hello"
      	@count=3
      	@bonus="This message came from the controller."
      end
    end

Then modify app/views/hello/index.html.erb:

    <h1><%= @message %></h1>
    <p>This is a greeting from app/views/hello/index.html.erb</p>
    <p><%= @bonus %></p>
    
Save the files and refresh the browser.

***
<sup>Tested and reconciled with changes made to book text</sup>