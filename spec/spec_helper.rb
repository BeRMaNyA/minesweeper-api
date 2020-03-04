# frozen_string_literal: true

$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), "../"))

require "rack/test"
require "rspec"
require "mongoid-rspec"

ENV["RACK_ENV"] = "test"
ENV["MONGO_URI"] ||= "mongodb://localhost:27017/minesweeper_test"

require "config/environment"

module RSpecMixin
  include Rack::Test::Methods

  def app; described_class end

  def json
    @json ||= JSON.parse(last_response.body)
  end
end

RSpec.configure do |config|
  config.include RSpecMixin
  config.include Mongoid::Matchers

  config.before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
