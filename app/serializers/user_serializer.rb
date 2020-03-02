# frozen_string_literal: true

require_relative "app_serializer"

class UserSerializer < AppSerializer
  def serialize(user)
    {
      id:       user.id.to_s,
      name:     user.name,
      username: user.username,
      token:    user.token
    }
  end
end
