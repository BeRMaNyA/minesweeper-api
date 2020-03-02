# frozen_string_literal: true

require "bundler"

ENV["RACK_ENV"] ||= "development"

Bundler.require(:default, ENV["RACK_ENV"])

require_relative "db"
require_relative "routes"

Dir.glob('./app/{models}/*.rb', &method(:require))
