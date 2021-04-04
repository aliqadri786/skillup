class CommentsController < ApplicationController
  before_action :set_lesson_course,  only: %i[create destroy]

    def create
      
      @comment = Comment.new(comment_params)
      @comment.user = current_user
      @comment.lesson_id = @lesson.id

      if @comment.save
        redirect_to course_lesson_path(@course,@lesson), notice: "Comment was successfully posted."        
      else
        redirect_to course_lesson_path(@course,@lesson), alert: "Something missing"
      end
    end

    def destroy     
      @comment = Comment.find(params[:id])
      authorize @comment
      @comment.destroy
      respond_to do |format|
        format.html { redirect_to course_lesson_path(@course,@lesson), notice: "Comment was successfully deleted." }
        format.json { head :no_content }
      end
    end

    private
    def set_lesson_course
      @course = Course.friendly.find(params[:course_id])
      @lesson = Lesson.friendly.find(params[:lesson_id])
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
    
    
end