# frozen_string_literal: true

class AuthController < AppController
  def login
    user = User.where(username: params.username).first

    validate_login!(user)
    
    user.set_jwt_token
    user.save

    json token: user.token
  end

  private

  def validate_login!(user)
    halt 401, error: "User doesn't exist" unless user

    user_password = BCrypt::Password.new(user.crypted_password)

    unless user_password == params.password
      halt 401, error: "Password doesn't match"
    end
  end
end
