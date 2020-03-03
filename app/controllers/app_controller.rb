# frozen_string_literal: true

class AppController < FitApi::Controller
  attr_accessor :serializer, :serializer_opts
  attr_reader :current_user, :scopes

  # GET /
  def root
    json "Minesweeper by Berna"
  end

  private

  # Override original json method in order to autoload the serializer
  # if it does exist
  #
  def json(status = 200, data)
    if [ Hash, Array ].include?(data)
      return super(status, data)
    end

    klass      = Array(data).first.class
    serializer = self.serializer || Object.const_get("#{klass}Serializer") rescue nil
    data       = serializer.new(data, self.serializer_opts || {}) if serializer

    super(status, data)
  end

  # Routes can be protected with this method:
  # before_action :authenticate!
  # If auth is success: current_user / scopes are available
  #
  def authenticate!
    payload, header = JWTAuth.decode_token(auth_token)

    user = User.where(
      _id:   payload["user"]["id"],
      token: auth_token
    ).first

    halt 401, error: "User not found" unless user

    @current_user = user
    @scopes       = payload["scopes"]

  rescue JWT::DecodeError
    halt 401, error: "A token must be passed"
  rescue JWT::ExpiredSignature
    halt 401, error: "The token has expired"
  rescue JWT::InvalidIssuerError
    halt 401, error: "The token doesn't have a valid issuer"
  rescue JWT::InvalidIatError
    halt 401, error: "The token does not have a valid \"issued at\" time"
  end

  def auth_token
    @auth_token ||= begin
      auth_header = request.headers["Authorization"]
      auth_header.split("Bearer").last.strip if auth_header
    end
  end

  # Paginate a Mongoid::Criteria
  def paginate(collection)
    page  = params[:page]  || 1
    limit = params[:limit] || 10

    collection.page(page).per(limit)
  end

  def check_scope!(scope)
    halt 401, error: "Unauthorized" unless scopes.include?(scope.to_s)
  end
end
