# LR5

_The following steps were used to recreate the Learning Rails 3 files within Ruby on Rails version 5.0.0.alpha. Development environment Ruby 2.2.2 and Rails 5.0.0.alpha on Ubuntu Linux version 14.04._

## Chapter 2

####"Creating Your Own View (hello01)"

    ~/projects/hello01/bin$ rails generate controller hello index

(config/routes.rb) Add the following line:

    root 'hello#index'
Save the edited routes.rb file and restart the server

    ~/projects/hello01/bin$ rails server

Change app/views/hello/index.html.erb to read as follows:

    <h1>Hello!</h1>
    <p>This is a greeting from app/views/hello/index.html.erb</p>
		
Save the file and refresh the browser.

***
<sup>Tested and reconciled with changes made to book text</sup>