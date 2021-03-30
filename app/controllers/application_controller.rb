class ApplicationController < ActionController::Base
    before_action :authenticate_user!, except: [:index]
    after_action :user_activity

    #pagy 
    include Pagy::Backend
    # / pagy

    # pundit
    include Pundit
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized   
    # / pundit

    # public activity
    include PublicActivity::StoreController #save current user
    # / public activity

    # ransack search
    before_action :set_global_variables
    def set_global_variables
        @ransack_courses=Course.ransack(params[:courses_search], search_key: :courses_search )
    end
    # / ransack search

    private

    def user_not_authorized #pundit
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to(request.referrer || root_path)
    end

    def user_activity
        current_user.try :touch
    end

end
