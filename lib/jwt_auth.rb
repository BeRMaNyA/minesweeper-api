# frozen_string_literal: true

require "jwt"

module JWTAuth
  DEFAULT_SCOPES = ["create_games", "play_games"]

  module_function

  def generate_token(user, scopes: DEFAULT_SCOPES)
    params = {
      exp: Time.now.to_i + 60 * 60,
      iat: Time.now.to_i,
      iss: ENV["JWT_ISSUER"],
      scopes: scopes,
      user: { id: user.id }
    }

    JWT.encode(params, ENV["JWT_SECRET"], "HS256")
  end
end
