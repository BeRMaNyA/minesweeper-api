# frozen_string_literal: true

class User
  include Mongoid::Document
  include ActiveModel::Validations

  attr_accessor :password

  field :name,             type: String
  field :username,         type: String
  field :crypted_password, type: String
  field :token,            type: String

  has_many :games, order: :created_at.desc,
                          validate: false

  validates :name, :username, :password, :token, presence: true
  validates :username, uniqueness: true, length: { minimum: 3 }
  validates :name, length: { minimum: 2 }
  validates :password, length: { minimum: 6 }

  index(username: 1, token: 1)

  def set_crypted_password
    self.crypted_password = BCrypt::Password.create(password)
  end

  def set_jwt_token
    self.token = JWTAuth.generate_token(self)
  end
end
