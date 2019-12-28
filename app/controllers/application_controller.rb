class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def missing_param(param)
    render json: {
      code: 422,
      error: "#{param} param required"
    }, status: 422
  end

  def invalid_param(param)
    render json: {
      code: 422,
      error: "#{param} param invalid"
    }, status: 422
  end

  def user_already_exists(email)
    render json: {
      code: 400,
      error: "#{email} already exists"
    }, status: 400
  end

  def header_missing(header)
    render json: {
      code: 401,
      error: "#{header} header required"
    }, status: 401
  end

  def invalid_header(header)
    render json: {
      code: 401,
      error: "#{header} header invalid"
    }, status: 401
  end

  def action_failed
    render json: {
      code: 400,
      error: "your request failed, please try again"
    }, status: 400
  end

  def render_server_error
    # Typically you want to set up some sort of Rails.logger here, but out of scope for this project
    render json: {
      code: 500,
      error: "application crash, we have been notified of this error"
    }, status: 500
  end

end
