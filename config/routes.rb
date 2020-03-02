# frozen_string_literal: true

FitApi::Router.auto_load_path "app/controllers"

FitApi::Router.define do
  root to: "app#root"

  resources :users, only: [:create]
  post :login, to: "auth#login"
end
