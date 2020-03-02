# frozen_string_literal: true

FitApi::Router.auto_load_path "app/controllers"

FitApi::Router.define do
  root to: "app#root"
end
