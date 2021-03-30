class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end  

  def index?
    is_admin?
  end

  def edit?
    is_admin?
  end

  def update?
    is_admin?
  end

  private 

  def is_admin?
    @user && @user.has_role?(:admin)
  end

end
