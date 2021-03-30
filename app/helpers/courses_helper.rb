module CoursesHelper
    def enrollment_button(course)
        if current_user
            if course.user == current_user
                
                link_to  analytics_course_path(course), class:"btn btn-primary btn-lg"    do
                    '<i class"fa fa-star"></i>'
                    "Show analytics"
                end
            elsif course.enrollments.where(user: current_user).any?
                link_to course_path(course) do
                    number_to_percentage(course.progress(current_user), precision: 0)
                end
            elsif course.price > 0
                form_tag course_enrollments_path(course) do
                    submit_tag "Buy Now", class:"btn btn-primary btn-block py-2"
                end
            else
                form_tag course_enrollments_path(course) do
                    submit_tag "Enroll Now", class:"btn btn-dark btn-block py-2"
                end
            end
        else
            link_to "Check Price", course_path(course), class:"btn btn-sm btn-secondary"
        end
    end

    def review_button(course)
        user_course = course.enrollments.where(user: current_user)
        if current_user
            if user_course.any?
                if user_course.pending_review.any?
                    link_to 'Add a review', edit_enrollment_path(user_course.first)
                else 
                    tag.i class: ' fa fa-star'
                end
            end  
        end
    end
    
end
