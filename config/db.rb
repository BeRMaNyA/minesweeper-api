# frozen_string_literal: true

Mongoid.configure do |config|
  config.clients.default = {
    uri: ENV["MONGO_URI"]
  }
end

Mongo::Logger.logger.level = Logger::FATAL
