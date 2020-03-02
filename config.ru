# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("./lib", __dir__)

require_relative "config/environment"

# Rack plugins

FitApi.use Rack::CommonLogger, Logger.new("log/app.log")

run FitApi.app
