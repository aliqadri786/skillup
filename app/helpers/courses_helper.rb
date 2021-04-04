module CoursesHelper
    def enrollment_button(course)
        if current_user
            if course.user == current_user
                
                link_to  analytics_course_path(course), class:"btn btn-primary btn-lg"    do
                    '<i class"fa fa-star"></i>'
                    "Show analytics"
                end
            elsif course.enrollments.where(user: current_user).any?
                link_to "", class:"btn btn-dark py-2 px-3" do                    
                    "Enrolled - #{number_to_percentage(course.progress(current_user), precision: 0)} completed"
                end
            elsif course.price > 0
                form_tag course_enrollments_path(course) do
                    tag.script class: 'stripe-button', "data-amount"=>"#{(course.price*100).to_i}",
                    "data-description"=>"#{course.title} #{(number_to_currency course.price)}",
                    "data-email"=>"#{current_user.email}",
                    "data-key"=>"pk_test_51IbPCoDfItNAcGyaeRlFuQv96rwExT37uaFvikgXqhDBOMkiWC8RVxtXOGM9bkJgB1f9Klrjtqq5aPONz8p9Y4nE00fPQodUfQ",
                    "data-locale"=>"auto",
                    :src=>"https://checkout.stripe.com/checkout.js"
                end
            else
                form_tag course_enrollments_path(course) do
                    submit_tag "Enroll Now", class:"btn btn-dark btn-lg"
                end
            end
        else
            link_to  course_enrollments_path(course), method: :post, class:"btn btn-primary py-2 px-3" do                    
                "Buy Course"
            end
        end
    end

    def review_button(course)
        user_course = course.enrollments.where(user: current_user)
        if current_user
            if user_course.any?
                if user_course.pending_review.any?
                    link_to 'Rate this course', edit_enrollment_path(user_course.first), class:"btn btn-warning px-3 py-2"
                
                    
                end
            end  
        end
    end

    def certificate_button(course)
        user_course = course.enrollments.where(user: current_user)
        if current_user
            if user_course.any?
                if(course).progress(current_user) == 100
                    link_to 'Get Certificate', certificate_enrollment_path(user_course.first, format: :pdf), class:"btn btn-primary text-white px-3 py-2"
                
                end  
            end
        end      
    end
    
    
end
