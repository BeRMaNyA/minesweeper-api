# frozen_string_literal: true

class UsersController < AppController
  def create
    user = User.new(user_params)

    if user.save 
      serialized_user = UserSerializer.new(user)

      json(201, serialized_user)
    else
      json(422, errors: user.errors.to_h)
    end
  end

  private

  def user_params
    params.user.permit(:name, :username, :password)
  end
end
