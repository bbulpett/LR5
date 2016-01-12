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