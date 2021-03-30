class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def destroy?
    @user && @user.id == @record.lesson.course.user_id
    is_owner? || is_admin?    
 end

 def owner?
  is_owner?
 end


  private  

  def is_owner?
    @user && @user == @record.user
  end

  def is_admin?
    @user.has_role?(:admin)
  end

end
