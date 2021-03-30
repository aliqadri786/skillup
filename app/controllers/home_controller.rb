class HomeController < ApplicationController
  def index
    @courses = Course.published.approved.limit(4)
  end

  def activity
    if current_user.has_role?(:admin)
      @pagy,@activities = pagy(PublicActivity::Activity.all.order(created_at: :desc))
    else 
      redirect_to root_path, alert:"You do not have access"
    end
  end

  def analytics
    if current_user.has_role?(:admin)
      # @users = User.all
      @enrollments = Enrollment.all
      @courses = Course.all 
    else 
      redirect_to root_path, alert:"You do not have access"
    end
  end
  
end
