class EnrollmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    is_admin? 
  end


  def edit?
    is_owner?
  end

  def update?
    is_owner?
  end

  def destroy?
    is_owner?
  end

  def certificate?
    @record.course.lessons_count == @record.course.user_lessons.where(user: @record.user).count 
  end
  
  private  

  def is_owner?
    @user && @user.id == @record.user_id
  end
  
  def is_admin?
    @user && @user.has_role?(:admin)
  end

end
