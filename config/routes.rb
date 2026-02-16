# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "auth/register", to: "auth#register"
      post "auth/login", to: "auth#login"

      get "current_user", to: "users#current"

      resources :assignments do
        resources :test_cases, only: %i[index create], controller: "assignment_test_cases"
        resources :submissions, only: :create
      end

      resources :test_cases, only: %i[update destroy], param: :test_case_id

      resources :submissions, only: %i[show update], param: :submission_id

      get "leaderboard", to: "leaderboard#index"
    end
  end
end
