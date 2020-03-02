# frozen_string_literal: true

module Users
  class CreateService
    attr_reader :user

    def initialize(params)
      @user = User.new(params)
    end

    def execute
      user.set_crypted_password
      user.save
      user
    end

    private

    def inject_attrs
      user.token = JWTAuth.generate_token(user)
    end
  end
end
