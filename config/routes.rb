# frozen_string_literal: true

FitApi::Router.auto_load_path "app/controllers"

FitApi::Router.define do
  root to: "app#root"

  resources :users, only: :create

  post :login, to: "auth#login"

  resources :games, only: %i(index create destroy) do
    member do
      post :pause
      post :resume
    end

    resource :board, only: :show do
      post :check
      post :mark
    end
  end
end
