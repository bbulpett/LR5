# Preview all emails at http://localhost:3000/rails/mailers/award_mailer
class AwardMailerPreview < ActionMailer::Preview
  def award_email
    AwardMailer.award_email(Award.first)
  end
end