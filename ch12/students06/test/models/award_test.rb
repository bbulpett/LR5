require 'test_helper'

class AwardTest < ActiveSupport::TestCase
    def test_validity_of_year
        #create new student for association in award
        student = Student.create({given_name: "Mark", date_of_birth: "1972-09-05",
                                  start_date: "2009-01-18"})

        # test for rejection of missing year
        award = Award.new({name: "Test award", student_id: student.id})
        assert !award.valid?

        # test under lower boundary
        award.year = 1979
        assert !award.valid?

        # lower boundary
        award.year = 1980
        assert award.valid?

        # top boundary
        award.year = Date.today.year
        assert award.valid?

        # top boundary case, award isn't valid for next year
        award.year = Date.today.year + 1
        assert !award.valid?
      end
end