# frozen_string_literal: true

module Api
  module V1
    class AuthController < Api::BaseController
      skip_before_action :authorize_access_request!, only: %i[register login]

      def register
        user = User.new(register_params)
        if user.save
          tokens = issue_tokens(user)
          render json: auth_response(tokens), status: :created
        else
          render json: { message: "Validation failed", errors: errors_format(user) }, status: :unprocessable_entity
        end
      end

      def login
        user = User.find_by(email: login_params[:email])
        if user&.authenticate(login_params[:password])
          tokens = issue_tokens(user)
          render json: auth_response(tokens), status: :ok
        else
          render json: { message: "Invalid user and/or password" }, status: :unauthorized
        end
      end

      private

      def register_params
        params.permit(:email, :password, :username).tap do |p|
          p[:role] = "student"
        end
      end

      def login_params
        params.permit(:email, :password)
      end

      def issue_tokens(user)
        payload = { user_id: user.id }
        JWTSessions::Session.new(payload: payload).login
      end

      def auth_response(tokens)
        {
          access_token: tokens[:access],
          token_type: "Bearer",
          expires_in: JWTSessions.access_exp_time
        }
      end

      def errors_format(record)
        record.errors.map { |e| { field: e.attribute.to_s, message: e.full_message } }
      end
    end
  end
end
