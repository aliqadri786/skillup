class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    @record.published && @record.approved || is_admin? || is_owner? || @record.bought(@user)
  end
  

  def new?
    is_teacher? 
  end

  def create?
    is_teacher?
  end

  def edit?
    is_owner?
  end

  def update?
    is_owner?
  end

  def destroy?
     is_owner? && @record.enrollments.none?
  end

  def approve?
    is_admin?
  end

  def owner?
    is_owner?
  end
  

  private  

  def is_owner?
    @user && @user == @record.user
  end

  def is_teacher?
    @user && @user.has_role?(:teacher)
  end

  def is_admin?
    @user && @user.has_role?(:admin)
  end

end
