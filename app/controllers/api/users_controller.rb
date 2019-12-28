class Api::UsersController < ApplicationController

  def create
    return missing_param('email') unless params[:email].present?
    return invalid_param('email') unless validate_email(params[:email])
    return user_already_exists(params[:email]) if find_user(params[:email]).present?

    token = generate_api_key
    hashed_api_key = hash_token(token)
    user = User.create(email: params[:email], hashed_token: hashed_api_key)
    render json: {
      code: 201,
      email: user.email,
      api_key: token
    }, status: 201
  rescue
    render_server_error
  end

  private

  def validate_email(email)
    EmailAddress.valid?(email)
  end

  def generate_api_key
    SecureRandom.alphanumeric(15)
  end

  def hash_token(token)
    BCrypt::Password.create(token)
  end

  def find_user(email)
    User.find_by_email(email)
  end
end
