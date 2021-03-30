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
  
  private  

  def is_owner?
    @user && @user.id == @record.user_id
  end
  
  def is_admin?
    @user && @user.has_role?(:admin)
  end

end
