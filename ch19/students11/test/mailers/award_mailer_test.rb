require 'test_helper'

class AwardMailerTest < ActionMailer::TestCase
  def award_email
    AwardMailer.award_email(Award.first)
  end
end
