#LR5

##Chapter 19 - Mail in Rails

####Receiving Mail
#####Setup

<sup>Refer to the chapter text for information on mail server setup.</sup>

#####Processing Messages

Mail can also be used to manipulate other logical parts of the application, such as updating database values. At the command prompt, enter the following command:

		rails generate mailer StudentMailer

Now, with the mailer base created, open *app/mailers/student_mailer.rb* in the text editor and enter the following code:

		class StudentMailer < ApplicationMailer

		  def receive(email)
		    return unless email.subject =~ /^Score/

		    sender = email.from[0]
		    user = User.find_by_email(sender)
		    unless user == 'edd@example.org'
		      logger.error "Refusing scores message from unauthorized sender"
		      return
		    end

		    # we've passed the first test -- email's from an admin user
		    # and has a subject starting with 'Score'

		    # extract the text content from the message
		    content = email.multipart? ? (email.text_part ? email.text_part.body.decoded :
		 nil) : email.body.decoded

		    # search through the content line-by-line for student and GPA
		    content.split(/\r?\n/).each do |l|
		      if l =~ /Student:\s*(\d+)/i then
		        @student = Student.find_by_id($1.to_i)
		      end
		      if l =~ /GPA:\s*(\d+\.\d+)/i then
		        @gpa = $1.to_f
		      end
		    end

		    # if the data's here, make the change.

		    if @student and @gpa
		      @student.update_attribute('grade_point_average', @gpa)
		      logger.info "Updated GPA of #{@student.name} to #{@gpa}"
		    else
		      logger.error "Couldn't interpret scores message"
		    end
		  end
		end

There's **alot** going on here, but essentially the receive method processes incoming emails to ensure that they are from an administrator. Then, it uses regex to extract the content before updating the student data with the new values. Note the use of the `logger` methods to quietly add debugging functionality.
