# frozen_string_literal: true

FitApi::Router.auto_load_path "app/controllers"

FitApi::Router.define do
  root to: "app#root"
  not_found to: "app#error_404"

  resources :users, only: :create

  post :login, to: "auth#login"

  resources :games, only: %i(index create destroy) do
    member do
      post :pause
      post :resume
    end

    resource :board, only: :show do
      post :check
      post :flag
      post :unflag
    end
  end
end
