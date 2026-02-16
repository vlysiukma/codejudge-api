# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization

  before_action :authorize_access_request!
  rescue_from JWTSessions::Errors::Unauthorized, with: :unauthorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def current_user
    @current_user ||= User.find_by!(id: payload["user_id"])
  end

  def unauthorized
    render json: { message: "Authentication token is missing or invalid" }, status: :unauthorized
  end

  def not_found
    render json: { message: "Resource not found" }, status: :not_found
  end
end
