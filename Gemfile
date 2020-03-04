source "https://rubygems.org"
ruby "2.7.0"

gem "fit_api",          "~> 1.1.3"
gem "mongoid",          "~> 7.0.5"
gem "kaminari-mongoid", "~> 1.0.1"
gem "bcrypt",           "~> 3.1.13"
gem "jwt",              "~> 2.2.1"
gem "micromachine",     "~> 3.0.0"
gem 'rack-cors',        '~> 1.0.3', require: 'rack/cors'

group :development do
  gem "dotenv", require: "dotenv/load"
  gem "pry"
  gem "byebug"
end

group :test do
  gem 'rspec',            '~> 3.8.0'
  gem 'rack-test',        '~> 1.1.0'
  gem 'database_cleaner', '~> 1.7.0'
  gem 'mongoid-rspec',    '~> 4.0.1'
end
