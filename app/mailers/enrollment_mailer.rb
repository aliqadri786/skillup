class EnrollmentMailer < ApplicationMailer

    def student_enrollment(enrollment)
        @enrollment = enrollment
        @course = enrollment.course
        mail(to: @enrollment.user.email, subject: "You have enrolled to #{@course.title}")
    end

    def teacher_enrollment(enrollment)
        @enrollment = enrollment
        @course = enrollment.course
        mail(to: @enrollment.course.user.email, subject: "You have a new student in course #{@course.title}")        
    end
    

end
