# frozen_string_literal: true

require "jwt"

module JWTAuth
  DEFAULT_SCOPES = %w(list_games create_game delete_game play_game)

  module_function

  # Generate a JWT token for a given user with scopes
  def generate_token(user, scopes: DEFAULT_SCOPES)
    params = {
      exp:    Time.now.to_i + 60 * 60,
      iat:    Time.now.to_i,
      iss:    ENV["JWT_ISSUER"],
      scopes: scopes,
      user:   { id: user.id.to_s }
    }

    JWT.encode(params, ENV["JWT_SECRET"], "HS256")
  end

  # Decode a JWT token
  def decode_token(token)
    options = {
      algorithm: "HS256",
      iss:       ENV["JWT_ISSUER"]
    }

    JWT.decode token, ENV["JWT_SECRET"], true, options
  end
end
