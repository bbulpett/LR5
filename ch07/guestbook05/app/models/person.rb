class Person < ApplicationRecord
	# the name is mandatory
	validates_presence_of :name

	# make the secret mandatory and provide a customized message
	validates_presence_of :secret, :message => "must be provided so we can recognize you in the future"

	# ensure secret has enough letters, but not too many
	validates_length_of :secret, :in => 6..24

	# ensure secret contains at least one number
	validates_format_of :secret, :with => /[0-9]/,
		:message => "must contain at least one number"

	# ensure secret contains at least one upper case letter
	validates_format_of :secret, :with => /[A-Z]/,
		:message => "must contain at least one upper case character"

	# ensure secret contains at least one lower case letter
	validates_format_of :secret, :with => /[a-z]/,
		:message => "must contain at least one lower case character"

	# the country field is a controlled vocabulary: we must check that 
	# its value is within our allowed options
	validates_inclusion_of :country, :in => ['Canada', 'Mexico', 'UK', 'USA'], :message => "must be one of Canada, Mexico, UK, or USA"

	# email should read like an email address. this check isn't exhaustive,
  # but it's a good start.
  validates_format_of :email, 
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    :message => "doesn't look like a proper email address"

  # how do we recognize the same person coming back? by their email address
  # so we want to ensure the same person only signs in once
  # adding the "scope" property allows us to check the email in other columns as well
  validates_uniqueness_of :email, :case_sensitive => false,
  	:scope => [:name, :secret],
    :message => "has already been entered, you can't sign in twice"

  # graduation year must be numeric, and within sensible bounds. however,
  # the person may not have graduated, so we allow a nil value too. finally
  # it must be a whole number (integer)
  validates_numericality_of :graduation_year, :allow_nil => true,
    :greater_than => 1920, :less_than_or_equal_to => Time.now.year,
    :only_integer => true

  # body temperature doesn't have to be a whole number, but we ought to
  # constrain possible values. we assume our users aren't in cryostasis
  validates_numericality_of :body_temperature, :allow_nil => true,
    :greater_than_or_equal_to => 60,
    :less_than_or_equal_to => 130, :only_integer => false
  
  validates_numericality_of :price, :allow_nil => true,
    :only_integer => false

  # restrict birthday to reasonable values, ie. not in the future and not
  # before 1900
  validates_inclusion_of :birthday,
    :in => Date.civil(1900, 1, 1) .. Date.today,
    :message => "must be between January 1st, 1900 and today"

  # finally, we just say that favorite time is mandatory. while the view
  # only allows you to post valid times, remember that models can be created
  # in other ways, such as from code or web service calls. so it's not safe
  # to make assumptions based on the form
  validates_presence_of :favorite_time
end
