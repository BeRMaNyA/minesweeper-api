# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("./lib", __dir__)

require_relative "config/environment"

# Rack plugins

FitApi.use Rack::Cors do |config|
  config.allow do |allow|
    allow.origins '*'
    allow.resource '/*',
      methods: %i(get post put delete),
      headers: :any,
      max_age: 0
  end
end

run FitApi.app
