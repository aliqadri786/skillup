class LessonPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    is_owner?
  end

  def create?
    is_owner?
  end

  def show?
    is_admin? || is_owner? || bought?
   
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
  
  private  

  def is_owner?
    @user && @user.id == @record.course.user_id
  end

  def is_teacher?
    @user && @user.has_role?(:teacher)
  end  

  def is_admin?
    @user && @user.has_role?(:admin)
  end

  def bought?
    @record.course.bought(@user) == true
  end

end
