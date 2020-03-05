# frozen_string_literal: true

class UsersController < AppController
  def create
    user = User.new(user_params)

    if user.save 
      json 201, user
    else
      json 422, errors: user.errors.to_h
    end
  end

  private

  def user_params
    params.permit(:name, :username, :password)
  end
end
