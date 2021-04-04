class Courses::CourseWizardController < ApplicationController   
    include Wicked::Wizard
    before_action :set_progress, only: [:show, :update]
    before_action :set_course, only: [:show, :update, :finish_wizard_path] 
    steps :basic_info, :details, :lessons

    def show
        # @user = current_user
        # case step
        # when :find_friends
        #   @friends = @user.find_friends
        # end
        authorize @course, :edit?
        @tags = Tag.all
        render_wizard
    end

    def finish_wizard_path
        authorize @course, :edit?
        course_path(@course)
    end

    def update
        authorize @course, :edit?
        case step
        when :basic_info           
        when :details
            @tags = Tag.all           
        when :lessons            
        end
        @course.update(course_params)
        render_wizard @course
    end
    

    private
    def set_progress
        if wizard_steps.any? && wizard_steps.index(step).present?
            @progress = ((wizard_steps.index(step)+1).to_d / wizard_steps.count.to_d) * 100
        else
            @progress = 0
        end
    end

    def set_course
        @course=Course.friendly.find(params[:course_id])        
    end
    

    def course_params
        params.require(:course).permit(:title, :description, :short_description, :language, :level, :price, :published, :avatar, tag_ids:[],
        lessons_attributes: [:id, :title, :content, :video, :video_thumbnail, :_detroy]
        )
    end
    

end
