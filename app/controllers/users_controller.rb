# frozen_string_literal: true

class UsersController < AppController
  def create
    service = Users::CreateService.new(user_params)
    user    = service.execute

    if user.persisted?
      json(201, user: user.attributes)
    else
      json(422, errors: user.errors.to_h)
    end
  end

  private

  def user_params
    params.user.permit(:name, :username, :password)
  end
end
