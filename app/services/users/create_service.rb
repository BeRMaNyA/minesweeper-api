# frozen_string_literal: true

module Users
  class CreateService
    attr_reader :user

    def initialize(params)
      @user = User.new(params)
    end

    def execute
      inject_attrs
      user.save
      user
    end

    private

    def inject_attrs
      user.crypted_password = BCrypt::Password.create(user.password)
      user.token = JWTAuth.generate_token(user)
    end
  end
end
