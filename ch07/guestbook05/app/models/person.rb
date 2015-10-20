class Person < ActiveRecord::Base
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
end
