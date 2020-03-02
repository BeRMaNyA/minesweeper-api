# frozen_string_literal: true

Mongoid.configure do |config|
  config.clients.default = {
    hosts: [ ENV["DB_HOST"] ],
    database: ENV["DB_NAME"],
  }
end
