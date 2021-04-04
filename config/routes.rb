Rails.application.routes.draw do
  
  resources :enrollments do
    get :my_students, on: :collection
    member do
      get :certificate
    end
  end
  devise_for :users
  
  resources :courses do

    get :purchased, :pending_review, :created, :unapproved, on: :collection
    member do
      get :analytics
      patch :approve
      patch :unapprove
    end
    resources :course_wizard, controller: 'courses/course_wizard'
    resources :lessons do
      resources :comments
      put :sort
      member do
        delete :delete_video
      end
    end
    resources :enrollments, only: [ :new, :create , :edit, :update]
  end

  resources :tags, only: [:create]
  
  resources :users, only: [:index, :edit, :show, :update]
  root "home#index"
  get "activity", to:"home#activity"
  get "analytics", to:"home#analytics"
  
  

  namespace :charts do
    get "users_per_day"
    get "enrollments_per_day"
    get "course_popularity"
    get "money_makers"
  end
end
